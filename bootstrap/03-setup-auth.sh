#!/bin/bash
# 03-setup-auth.sh: Cria Segredos de autenticação global no Kubernetes
set -e

# Carrega variáveis
if [ -f .env ]; then
  source .env
else
  echo "Erro: Arquivo .env não encontrado!"
  exit 1
fi

echo "--- 1. Criando Secret homelab-auth nas namespaces apps e infra ---"

# Cria a namespace infra se não existir (necessário para o Postgres)
kubectl create namespace infra || true
# Cria a namespace apps se não existir
kubectl create namespace apps || true

# Cria o segredo na namespace infra
kubectl create secret generic homelab-auth \
  --from-literal=username="$BASE_USER" \
  --from-literal=password="$BASE_PASSWORD" \
  -n infra --dry-run=client -o yaml | kubectl apply -f -

# Cria o segredo na namespace apps
kubectl create secret generic homelab-auth \
  --from-literal=username="$BASE_USER" \
  --from-literal=password="$BASE_PASSWORD" \
  -n apps --dry-run=client -o yaml | kubectl apply -f -

echo "--- ✅ Secrets de autenticação criados com sucesso! ---"
