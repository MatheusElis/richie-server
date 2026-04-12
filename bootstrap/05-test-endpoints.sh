#!/bin/bash
# 05-test-endpoints.sh: Testa todos os serviços via Ingress com curl
set -e

# Carrega variáveis
if [ -f .env ]; then
  source .env
else
  DOMAIN="cusin-server.duckdns.org"
fi

echo "--- ⏳ Aguardando 120 segundos para estabilização final do cluster... ---"
sleep 120

echo -e "\n--- 🔍 Testando Endpoints via Ingress ---"

# Lista de apps e seus caminhos de teste
declare -A apps=( 
  ["Homepage"]="https://homepage.$DOMAIN"
  ["ArgoCD"]="https://argocd.$DOMAIN"
  ["qBittorrent"]="https://qbittorrent.$DOMAIN"
  ["Kavita"]="https://kavita.$DOMAIN"
  ["Calibre"]="https://calibre.$DOMAIN"
  ["Joplin"]="https://joplin.$DOMAIN/ping"
  ["Nextcloud"]="https://cloud.$DOMAIN"
  ["Filebrowser"]="https://files.$DOMAIN"
)

failed=0

for name in "${!apps[@]}"; do
  url="${apps[$name]}"
  echo -n "Testing $name ($url)... "
  
  # -k para ignorar SSL auto-assinado, -s para silencioso, -o /dev/null para não mostrar corpo, -w para mostrar status code
  status=$(curl -Is -k "$url" | head -n 1 | awk '{print $2}')
  
  if [[ "$status" =~ ^(200|302|307|400|401)$ ]]; then
    echo -e "✅ \e[32mOK ($status)\e[0m"
  else
    echo -e "❌ \e[31mFAIL ($status)\e[0m"
    failed=$((failed + 1))
  fi
done

if [ $failed -eq 0 ]; then
  echo -e "\n--- ✨ Todos os serviços estão respondendo corretamente! ---"
else
  echo -e "\n--- ⚠️ $failed serviço(s) apresentaram falha. Verifique os logs com 'kubectl logs'. ---"
  exit 1
fi
