#!/bin/bash
# 02-install-k3s.sh: Instala o k3s
set -e

echo "--- 1. Instalando o k3s (Single Node) ---"
# --write-kubeconfig-mode 644 para permitir que o user elis use o kubectl sem sudo
# O k3s já vem com o Traefik por padrão, o que atende nossa necessidade de simplicidade.
curl -sfL https://get.k3s.io | sh -s - \
  --write-kubeconfig-mode 644

echo "--- 2. Verificando o estado do cluster ---"
# Aguarda um pouco para o node ficar Ready
sleep 10
kubectl get nodes

echo "--- ✅ k3s instalado com sucesso! ---"
