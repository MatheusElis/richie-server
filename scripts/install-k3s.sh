#!/bin/bash
set -e

# Parâmetros
K3S_VERSION="v1.31.1+k3s1"
NODE_NAME="cusin"

echo "🚀 Iniciando a instalação do k3s no nó ${NODE_NAME}..."

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${K3S_VERSION} sh -s - server \
    --disable traefik \
    --write-kubeconfig-mode 644 \
    --node-name ${NODE_NAME}

echo "⏳ Aguardando o nó ficar Ready..."
sleep 15
kubectl get nodes
echo "✅ Instalação do k3s concluída com sucesso!"
