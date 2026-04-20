# Hardware

## Servidor Principal — `cusin`

| Componente | Detalhes |
|------------|----------|
| **Hostname** | cusin |
| **CPU** | Intel Core i5-3570 @ 3.40GHz (4 cores, 1 thread/core, max 3.8GHz) |
| **RAM** | 7.6 GB + 4 GB Swap |
| **Disco** | SSD 223.6 GB (AS-240) — montado em `/` |
| **Rede** | Interface `eno1` — IP local: `192.168.31.55/24` |
| **OS** | Ubuntu 24.04.4 LTS (Noble Numbat) |
| **Kernel** | 6.8.0-110-generic x86_64 |

## Observações

- Single-node: todo o cluster Kubernetes roda neste único host
- Sem redundância de armazenamento — disco único
- Recursos modestos — stack escolhida para minimizar overhead (K3s, manifests puros quando possível)
- Swap configurada para aliviar pressão de memória em picos
