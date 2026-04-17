# GEMINI.md - Diretrizes do Projeto Richie Server

## 🎯 Objetivo Geral
Transformar o servidor **cusin** em um laboratório de Kubernetes (k3s) e GitOps (ArgoCD) de alta fidelidade, utilizando padrões de mercado e garantindo reprodutibilidade total.

## 🛠️ Fluxo de Trabalho Obrigatório
Nenhuma tarefa (Story/Epic) deve ser movida ou concluída sem passar por este ciclo:
1. **Refinar (Discovery/Planejamento):** Discussão técnica, definição de parâmetros e validação de requisitos. **Nesta fase, as sub-tarefas técnicas devem ser explicitamente listadas na Issue.**
2. **Desenvolver:** Escrita do código, manifestos ou scripts.
3. **Testar:** Validação técnica do que foi desenvolvido (logs, status de pods, conectividade).
4. **Deploy/Commit:** Persistência no repositório Git e atualização final do Kanban.

## 📋 Gerenciamento de Estado e Sessões
- **Contexto de Board:** O Kanban deve ser a fonte absoluta da verdade para o estado atual. 
- **Sub-tarefas:** Histórias complexas devem ter checklists de tarefas (Task Lists) nas Issues para que o progresso parcial seja visível.
- **Continuidade:** Ao final de cada sessão, o board deve refletir exatamente o que foi feito e o que é o próximo passo imediato.

## 🏗️ Padrões de Arquitetura e Infraestrutura
- **Reprodutibilidade:** O setup base deve ser executado via `Makefile`. O objetivo é que uma nova instalação do Ubuntu 24.04 possa ser provisionada rapidamente.
- **Abordagem GitOps:** Priorizar a instalação de componentes (Traefik, Cert-manager) via ArgoCD em vez de instalação manual no k3s.
- **Segurança:** O acesso ao `kubectl` é restrito ao SSH no servidor **cusin**.
- **Ingress:** Traefik nativo do k3s deve ser desativado para uso de versões completas via Helm/ArgoCD.
- **DNS/SSL:** Utilização de domínio próprio (`bisnaguete.xyz`) via Cloudflare com automação via Cert-manager (DNS-01 Challenge).

## 🗂️ Estrutura do Repositório
- `/clusters/cusin`: Configurações específicas do cluster.
- `/infrastructure`: Manifestos de base (ArgoCD, Traefik, etc).
- `/apps`: Aplicações do usuário.
- `Makefile`: Orquestração de comandos de setup inicial.

---
*Este arquivo é uma bússola para o comportamento da IA neste projeto. As diretrizes aqui contidas têm precedência absoluta.*
