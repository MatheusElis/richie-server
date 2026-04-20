#!/usr/bin/env bash
# Gera um Kubernetes Secret YAML e encripta com kubeseal (sem precisar de kubectl)
# Uso: ./scripts/seal.sh <nome> <namespace> <chave=valor> [chave=valor ...]
# Exemplo:
#   ./scripts/seal.sh cloudflare-api-token cert-manager api-token=MEU_TOKEN
#   ./scripts/seal.sh postgresql-credentials postgresql postgres-password=SENHA
#   ./scripts/seal.sh pgadmin-credentials pgadmin email=admin@bisnaguete.xyz password=SENHA

set -e

NAME=$1
NAMESPACE=$2
shift 2

if [ -z "$NAME" ] || [ -z "$NAMESPACE" ] || [ $# -eq 0 ]; then
  echo "Uso: $0 <nome> <namespace> <chave=valor> [chave=valor ...]"
  exit 1
fi

CERT="${HOME}/.homelab/sealed-secrets-cert.pem"
if [ ! -f "$CERT" ]; then
  echo "❌ Certificado não encontrado em $CERT. Execute 'make gen-keys' primeiro."
  exit 1
fi

DATA=""
for kv in "$@"; do
  KEY="${kv%%=*}"
  VALUE="${kv#*=}"
  B64=$(printf '%s' "$VALUE" | base64 -w0)
  DATA="${DATA}  ${KEY}: ${B64}\n"
done

printf 'apiVersion: v1\nkind: Secret\nmetadata:\n  name: %s\n  namespace: %s\ntype: Opaque\ndata:\n%b' \
  "$NAME" "$NAMESPACE" "$DATA" \
  | kubeseal --cert "$CERT" -o yaml
