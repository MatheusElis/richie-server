ANSIBLE_PLAYBOOK = ansible/playbooks/site.yml
ANSIBLE_INVENTORY = ansible/inventory/hosts.yml
ANSIBLE_CMD       = ansible-playbook -i $(ANSIBLE_INVENTORY) --ask-become-pass

SEALED_SECRETS_KEY ?= $(HOME)/.homelab/sealed-secrets-key.yaml
KUBESEAL_VERSION   = 0.27.0

.DEFAULT_GOAL := help

##@ Fluxo Principal

.PHONY: install
install: deps ## Instala tudo do zero: OS + K3s + ArgoCD
	$(ANSIBLE_CMD) $(ANSIBLE_PLAYBOOK)

.PHONY: reset
reset: uninstall install ## Derruba e recria o cluster completo

##@ Targets Individuais

.PHONY: os
os: ## Configura o OS (role common)
	$(ANSIBLE_CMD) $(ANSIBLE_PLAYBOOK) --tags common

.PHONY: k3s
k3s: ## Instala/configura o K3s (role k3s)
	$(ANSIBLE_CMD) $(ANSIBLE_PLAYBOOK) --tags k3s

.PHONY: argocd
argocd: ## Faz o bootstrap do ArgoCD no cluster
	$(ANSIBLE_CMD) $(ANSIBLE_PLAYBOOK) --tags argocd

##@ Secrets

.PHONY: gen-keys
gen-keys: ## Gera o par de chaves do Sealed Secrets (executar uma vez no primeiro setup)
	@mkdir -p $(HOME)/.homelab
	@if [ -f "$(SEALED_SECRETS_KEY)" ]; then \
		echo "⚠️  Chave já existe em $(SEALED_SECRETS_KEY). Use 'make rotate-keys' para rotacionar."; \
		exit 1; \
	fi
	@echo "🔑 Gerando par de chaves RSA 4096..."
	@openssl genrsa -out $(HOME)/.homelab/sealed-secrets-key.pem 4096 2>/dev/null
	@openssl req -new -x509 \
		-key $(HOME)/.homelab/sealed-secrets-key.pem \
		-out $(HOME)/.homelab/sealed-secrets-cert.pem \
		-days 3650 \
		-subj "/CN=sealed-secret/O=sealed-secret" 2>/dev/null
	@KEY_B64=$$(base64 -w0 < $(HOME)/.homelab/sealed-secrets-key.pem) && \
	CERT_B64=$$(base64 -w0 < $(HOME)/.homelab/sealed-secrets-cert.pem) && \
	printf 'apiVersion: v1\nkind: Secret\nmetadata:\n  name: sealed-secrets-key\n  namespace: kube-system\n  labels:\n    sealedsecrets.bitnami.com/sealed-secrets-key: active\ntype: kubernetes.io/tls\ndata:\n  tls.crt: %s\n  tls.key: %s\n' "$$CERT_B64" "$$KEY_B64" > $(SEALED_SECRETS_KEY)
	@rm -f $(HOME)/.homelab/sealed-secrets-key.pem
	@echo "✅ Chave privada salva em $(SEALED_SECRETS_KEY)"
	@echo "✅ Certificado público salvo em $(HOME)/.homelab/sealed-secrets-cert.pem"
	@echo ""
	@echo "⚠️  Faça backup de $(SEALED_SECRETS_KEY) em local seguro antes de continuar!"
	@echo ""
	@echo "Para encriptar secrets use:"
	@echo "  kubeseal --cert ~/.homelab/sealed-secrets-cert.pem -o yaml < secret.yaml > sealed-secret.yaml"

.PHONY: rotate-keys
rotate-keys: ## Gera novas chaves e re-encripta todos os SealedSecrets do repo
	@echo "🔄 Gerando nova chave..."
	@rm -f $(SEALED_SECRETS_KEY)
	@$(MAKE) gen-keys
	@echo "🔄 Aplicando nova chave no cluster..."
	@kubectl apply -f $(SEALED_SECRETS_KEY)
	@kubectl rollout restart deployment/sealed-secrets-controller -n kube-system
	@echo "🔄 Re-encriptando todos os SealedSecrets..."
	@find . -name "sealed-secret.yaml" | while read f; do \
		dir=$$(dirname $$f); \
		echo "  → $$f"; \
		kubeseal --re-encrypt < $$f > $$f.tmp && mv $$f.tmp $$f; \
	done
	@echo "✅ Rotação concluída. Faça commit dos arquivos atualizados."

##@ Remoção

.PHONY: uninstall
uninstall: ## Remove o K3s preservando ~/.homelab/ e /opt/homelab/
	@echo "⚠️  Removendo K3s..."
	@if [ -f /usr/local/bin/k3s-uninstall.sh ]; then \
		sudo /usr/local/bin/k3s-uninstall.sh; \
	else \
		echo "K3s não encontrado, nada a remover."; \
	fi
	@rm -f $(HOME)/.kube/config
	@echo "✅ K3s removido. Dados em /opt/homelab/ e $(HOME)/.homelab/ preservados."

##@ Dependências

.PHONY: deps
deps: ## Verifica e instala ferramentas necessárias (ansible, helm, kubeseal)
	@echo "🔍 Verificando dependências..."
	@$(MAKE) _check-ansible
	@$(MAKE) _check-helm
	@$(MAKE) _check-kubeseal
	@echo "✅ Todas as dependências estão instaladas."

.PHONY: _check-ansible
_check-ansible:
	@if ! command -v ansible-playbook &>/dev/null; then \
		echo "📦 Instalando Ansible..."; \
		pip install --user ansible; \
	else \
		echo "  ✓ ansible $(shell ansible --version | head -1 | awk '{print $$3}' | tr -d ']')"; \
	fi

.PHONY: _check-helm
_check-helm:
	@if ! command -v helm &>/dev/null; then \
		echo "📦 Instalando Helm..."; \
		curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash; \
	else \
		echo "  ✓ helm $(shell helm version --short 2>/dev/null)"; \
	fi

.PHONY: _check-kubeseal
_check-kubeseal:
	@if ! command -v kubeseal &>/dev/null; then \
		echo "📦 Instalando kubeseal v$(KUBESEAL_VERSION)..."; \
		curl -fsSL https://github.com/bitnami-labs/sealed-secrets/releases/download/v$(KUBESEAL_VERSION)/kubeseal-$(KUBESEAL_VERSION)-linux-amd64.tar.gz \
			| tar xz -C /tmp kubeseal; \
		sudo mv /tmp/kubeseal /usr/local/bin/kubeseal; \
	else \
		echo "  ✓ kubeseal $(shell kubeseal --version 2>/dev/null | awk '{print $$NF}')"; \
	fi

##@ Utilitários

.PHONY: help
help: ## Mostra este menu de ajuda
	@awk 'BEGIN {FS = ":.*##"; printf "\nUso:\n  make \033[36m<target>\033[0m\n"} \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
