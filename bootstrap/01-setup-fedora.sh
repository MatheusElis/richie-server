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
# Estrutura de Downloads e Media
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

# Estrutura de Configurações centralizada
mkdir -p "$BASE_DATA_PATH/configs/qbittorrent" \
         "$BASE_DATA_PATH/configs/kavita" \
         "$BASE_DATA_PATH/configs/calibre" \
         "$BASE_DATA_PATH/configs/joplin" \
         "$BASE_DATA_PATH/configs/filebrowser" \
         "$BASE_DATA_PATH/configs/homepage" \
         "$BASE_DATA_PATH/configs/nextcloud" \
         "$BASE_DATA_PATH/configs/postgres"

echo "--- 2. Ajustando permissões (usuário elis - 1000:1000) ---"
sudo chown -R 1000:1000 "$BASE_DATA_PATH"
# Garante que as pastas de config tenham permissão de escrita
sudo chmod -R 775 "$BASE_DATA_PATH/configs"

# Ajuste específico para o PostgreSQL (UID 999)
echo "--- 2.1 Ajustando permissões para o PostgreSQL (UID 999) ---"
sudo chown -R 999:999 "$BASE_DATA_PATH/configs/postgres"
sudo chmod -R 700 "$BASE_DATA_PATH/configs/postgres"

echo "--- 3. Configurando SELinux ---"
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
