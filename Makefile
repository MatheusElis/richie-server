# Makefile para automação do Homelab

.PHONY: setup-os install-k3s setup-auth setup-argocd test teardown install

# Atalho para executar todos os passos de instalação
install: setup-os install-k3s setup-auth setup-argocd test

setup-os:
	@echo "--- 🛠️ Preparando Sistema Operacional Ubuntu ---"
	cd bootstrap && ./01-setup-ubuntu.sh

install-k3s:
	@echo "--- ☸️ Instalando Cluster k3s ---"
	cd bootstrap && ./02-install-k3s.sh

setup-auth:
	@echo "--- 🔐 Configurando Autenticação Global ---"
	cd bootstrap && ./03-setup-auth.sh

setup-argocd:
	@echo "--- 🚢 Iniciando GitOps com ArgoCD ---"
	cd bootstrap && ./04-setup-argocd.sh

test:
	@echo "--- 🧪 Validando Endpoints das Aplicações ---"
	cd bootstrap && ./05-test-endpoints.sh

teardown:
	@echo "--- 🧨 Removendo toda a infraestrutura ---"
	cd bootstrap && ./99-teardown.sh
