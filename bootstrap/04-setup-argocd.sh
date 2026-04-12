#!/bin/bash
# 04-setup-argocd.sh: Instala o ArgoCD e faz o bootstrap do repositório privado
set -e

# Carrega variáveis
if [ -f .env ]; then
  source .env
else
  echo "Erro: Arquivo .env não encontrado!"
  exit 1
fi

# Tenta ler o token do .env ou do arquivo fallback /home/elis/github_token
if [ -z "$GITHUB_TOKEN" ]; then
    if [ -f "/home/elis/github_token" ]; then
        echo "Lendo GITHUB_TOKEN de /home/elis/github_token"
        GITHUB_TOKEN=$(cat /home/elis/github_token)
    else
        echo "Erro: GITHUB_TOKEN não definido e /home/elis/github_token não encontrado!"
        exit 1
    fi
fi

# Pega a URL do repositório atual e garante que seja HTTPS para usar com o PAT
REPO_URL="https://github.com/MatheusElis/richie-server.git"

echo "--- 1. Instalando ArgoCD ---"
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --server-side --force-conflicts

echo "--- 2. Aguardando pods do ArgoCD ---"
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

echo "--- 3. Registrando repositório privado no ArgoCD ---"
# O ArgoCD precisa do token para monitorar este repositório privado
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: github-repo-creds
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: $REPO_URL
  password: $GITHUB_TOKEN
  username: git
EOF

echo "--- 4. Aplicando o Root Application (App of Apps) ---"
# Assumindo que o arquivo root-app.yaml existirá no path clusters/root-app.yaml
kubectl apply -f ../clusters/root-app.yaml

echo "--- ✅ ArgoCD instalado e bootstrap iniciado! ---"
echo "A senha inicial do ArgoCD pode ser obtida com:"
echo 'kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo'
