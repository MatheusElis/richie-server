# Orquestração do Setup Richie Server

.PHONY: help install-k3s uninstall-k3s check-status

help:
	@echo "Comandos disponíveis:"
	@echo "  make install-k3s   - Instala o cluster k3s (sem Traefik)"
	@echo "  make uninstall-k3s - Remove completamente o k3s"
	@echo "  make check-status  - Verifica a saúde do nó e dos pods"

## Instala o k3s chamando o script externo
install-k3s:
	@bash scripts/install-k3s.sh

## Remove o k3s chamando o script externo
uninstall-k3s:
	@bash scripts/uninstall-k3s.sh

## Verifica a saúde do cluster
check-status:
	@echo "--- STATUS DOS NÓS ---"
	@kubectl get nodes -o wide
	@echo "\n--- STATUS DOS PODS ---"
	@kubectl get pods -A
