#!/bin/bash
# 99-teardown.sh: Desinstala o k3s e apaga todos os dados do Homelab (Reset Total)
set -e

# Carrega variáveis
if [ -f .env ]; then
  source .env
else
  BASE_DATA_PATH="/home/elis/data"
fi

echo "🛑 ATENÇÃO: Isso apagará TODOS os contêineres, o cluster Kubernetes e a pasta $BASE_DATA_PATH (incluindo mídias e configs)."
read -p "Tem certeza que deseja continuar? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]
then
    echo "Cancelado."
    exit 1
fi

echo "--- 1. Desinstalando k3s e ArgoCD ---"
if [ -f /usr/local/bin/k3s-uninstall.sh ]; then
    sudo /usr/local/bin/k3s-uninstall.sh
else
    echo "k3s-uninstall.sh não encontrado. O k3s já pode ter sido removido."
fi

echo "--- 2. Apagando dados em $BASE_DATA_PATH ---"
sudo rm -rf "$BASE_DATA_PATH"

echo "--- ✅ Homelab resetado com sucesso! Você pode executar os scripts 01, 02 e 03 novamente. ---"
