#!/bin/bash
# 01-setup-fedora.sh: Prepara o SO Fedora para rodar o Homelab
set -e

# Carrega variáveis
if [ -f .env ]; then
  source .env
else
  echo "Erro: Arquivo .env não encontrado no diretório atual!"
  exit 1
fi

echo "--- 1. Criando estrutura de diretórios em $BASE_DATA_PATH ---"
mkdir -p "$BASE_DATA_PATH/downloads/complete/audiobooks" \
         "$BASE_DATA_PATH/downloads/complete/books" \
         "$BASE_DATA_PATH/downloads/complete/movies" \
         "$BASE_DATA_PATH/downloads/complete/tv" \
         "$BASE_DATA_PATH/downloads/incomplete" \
         "$BASE_DATA_PATH/media/audiobooks" \
         "$BASE_DATA_PATH/media/books" \
         "$BASE_DATA_PATH/media/movies" \
         "$BASE_DATA_PATH/media/tv" \
         "$BASE_DATA_PATH/nextcloud-data"

echo "--- 2. Ajustando permissões (usuário elis - 1000:1000) ---"
# No Fedora Server, o primeiro usuário comum geralmente é 1000
sudo chown -R 1000:1000 "$BASE_DATA_PATH"

echo "--- 3. Configurando SELinux ---"
# Permite que o k3s/contêineres acessem o hostPath no Fedora
if command -v semanage &> /dev/null; then
  sudo semanage fcontext -a -t svirt_sandbox_file_t "$BASE_DATA_PATH(/.*)?" || true
  sudo restorecon -Rv "$BASE_DATA_PATH"
else
  echo "Aviso: semanage não encontrado. Usando chcon como fallback."
  sudo chcon -Rt svirt_sandbox_file_t "$BASE_DATA_PATH"
fi

echo "--- 4. Configurando Firewall ---"
sudo firewall-cmd --add-service=http --add-service=https --permanent
sudo firewall-cmd --add-port=6443/tcp --permanent
sudo firewall-cmd --reload

echo "--- ✅ Setup inicial do Fedora concluído! ---"
