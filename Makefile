# Orquestração do Setup Richie Server

.PHONY: help install-tools install-k3s uninstall-k3s check-status install-argocd

help:
	@echo "Comandos disponíveis:"
	@echo "  make install-tools   - Instala as ferramentas auxiliares (Helm, etc)"
	@echo "  make install-k3s     - Instala o cluster k3s (sem Traefik)"
	@echo "  make uninstall-k3s   - Remove completamente o k3s"
	@echo "  make check-status    - Verifica a saúde do nó e dos pods"
	@echo "  make install-argocd  - Instala o ArgoCD via Helm (Bootstrap)"

## Instala as ferramentas
install-tools:
	@bash scripts/install-tools.sh

## Instala o k3s chamando o script externo
install-k3s:
	@bash scripts/install-k3s.sh

## Remove o k3s chamando o script externo
uninstall-k3s:
	@bash scripts/uninstall-k3s.sh

## Instala o ArgoCD chamando o script externo
install-argocd:
	@bash scripts/install-argocd.sh

## Verifica a saúde do cluster
check-status:
	@echo "--- STATUS DOS NÓS ---"
	@kubectl get nodes -o wide
	@echo "\n--- STATUS DOS PODS (All Namespaces) ---"
	@kubectl get pods -A
