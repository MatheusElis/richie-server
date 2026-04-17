#!/bin/bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
set -e

NAMESPACE="argocd"
CHART_VERSION="7.6.4" # Argo CD 2.12.x
# Hash Bcrypt para a senha: Bisnaguete0312#
ADMIN_PASSWORD_HASH='$2b$10$Fg6tFA.nCJ9z9QyZsaJWNuCg41xvXtF1RtxXAq8GblbKyFhdyBVz6'

echo "🚀 Iniciando o Bootstrap do ArgoCD no namespace ${NAMESPACE}..."

# Criar o namespace se não existir
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Adicionar o repositório Helm e atualizar
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Instalar ArgoCD com configuração não-HA e SENHA PRÉ-DEFINIDA
# Desativamos o HA (High Availability) para rodar em nó único com menos pods
helm upgrade --install argocd argo/argo-cd \
    --version ${CHART_VERSION} \
    --namespace ${NAMESPACE} \
    --set global.logging.level=info \
    --set server.service.type=ClusterIP \
    --set controller.replicas=1 \
    --set repoServer.replicas=1 \
    --set applicationSet.replicas=1 \
    --set server.replicas=1 \
    --set configs.secret.argocdServerAdminPassword=${ADMIN_PASSWORD_HASH}

echo "✅ ArgoCD instalado com sucesso!"
echo "🔍 Verifique o status com: kubectl get pods -n ${NAMESPACE}"
echo "🚪 Senha inicial configurada. Consulte o README.md para o primeiro acesso."
