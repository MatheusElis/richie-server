#!/bin/bash

echo "🛑 Removendo o k3s do sistema..."

if [ -f /usr/local/bin/k3s-uninstall.sh ]; then
    sudo /usr/local/bin/k3s-uninstall.sh
else
    echo "⚠️ k3s-uninstall.sh não encontrado. O k3s já deve estar desinstalado."
fi

echo "🧹 Limpeza concluída."
