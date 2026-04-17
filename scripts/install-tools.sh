#!/bin/bash
set -e

echo "🛠️ Instalando ferramentas auxiliares (Helm)..."

# Instalação do Helm (Script oficial)
if ! command -v helm &> /dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "✅ Helm instalado com sucesso!"
else
    echo "ℹ️ Helm já está instalado."
fi

# Futuras ferramentas podem ser adicionadas aqui
# echo "🛠️ Instalando Kubeseal..."

echo "🚀 Ferramentas instaladas e prontas para o uso!"
