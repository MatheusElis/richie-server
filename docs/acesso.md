# Como Acessar os Serviços

## Pré-requisito

O acesso funciona apenas na rede local. Certifique-se de estar conectado à mesma rede que o servidor (`192.168.31.55`).

## DNS Local

Para que os subdomínios resolvam na sua máquina local, adicione ao `/etc/hosts` (ou configure no roteador):

```
192.168.31.55  home.bisnaguete.xyz
192.168.31.55  pgadmin.bisnaguete.xyz
192.168.31.55  traefik.bisnaguete.xyz
```

> **Alternativa:** Configure o DNS wildcard `*.bisnaguete.xyz → 192.168.31.55` no seu roteador para não precisar adicionar cada subdomínio manualmente.

## Serviços Disponíveis

| Serviço | URL | Descrição |
|---------|-----|-----------|
| Glance | https://home.bisnaguete.xyz | Dashboard / Homepage |
| pgAdmin | https://pgadmin.bisnaguete.xyz | Administração do PostgreSQL |
| Traefik | https://traefik.bisnaguete.xyz | Dashboard do Ingress |

## TLS

Os certificados são emitidos pelo Let's Encrypt via DNS-01 challenge (Cloudflare). Na primeira execução, aguarde alguns minutos para os certificados serem emitidos.

## ArgoCD

O ArgoCD não possui Ingress configurado (acesso headless). Para acessar:

```bash
# Port-forward temporário
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Ou via CLI
argocd login localhost:8080
```
