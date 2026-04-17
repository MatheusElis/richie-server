# GEMINI.md - Diretrizes do Projeto Richie Server

## 🎯 Objetivo Geral
Transformar o servidor **cusin** em um laboratório de Kubernetes (k3s) e GitOps (ArgoCD) de alta fidelidade, utilizando padrões de mercado e garantindo reprodutibilidade total.

## 🚨 PROTOCOLO DE INICIALIZAÇÃO DE SESSÃO (MANDATÓRIO)
A **primeira ação** de QUALQUER nova sessão com a IA neste projeto DEVE ser a verificação do estado atual do Kanban Board. 
- **NÃO** inicie implementações ou sugestões sem antes sincronizar o contexto lendo o board.
- **Comando de verificação CLI:** `gh project item-list 2 --owner MatheusElis --format json` (ou equivalente que retorne o status dos itens).
- Alternativamente, liste as issues abertas e seus status associados no projeto.

## 📋 Gerenciamento de Estado e Kanban Board
O GitHub Project (Kanban) é a **fonte absoluta da verdade** para o estado do projeto.

### Como Acessar o Board
- **Visualização Web:** [Richie Server Board (ID 2)](https://github.com/users/MatheusElis/projects/2)
- **Visualização CLI:** `gh issue list --repo MatheusElis/richie-server` (para ver as tarefas abertas) e `gh project item-list 2 --owner MatheusElis` (para ver o status no board).

### Como Interpretar as Colunas do Board
- **Backlog:** Ideias, épicos não detalhados e tarefas futuras. Sem ação imediata necessária.
- **Ready for Development:** Tarefas que já passaram pela fase de **Refinamento** (discovery). Possuem escopo claro, parâmetros definidos e checklists (Task Lists) explícitas no corpo da Issue. Estão prontas para código.
- **In Progress:** A tarefa que está sendo ativamente desenvolvida e testada na sessão atual. **Apenas UMA tarefa (Story) deve estar ativamente em progresso por vez.**
- **Done:** Tarefas concluídas, com código commitado no repositório (`Deploy/Commit` realizado).

### Regras de Ouro do Board
- **Continuidade:** Ao final de cada sessão, o board **deve** refletir exatamente o que foi feito e qual é o próximo passo imediato na coluna `Ready for Development`.
- **Sub-tarefas:** Histórias complexas DEVEM ter checklists de tarefas (Task Lists) nas Issues. Conforme a IA progride, os checkboxes devem ser marcados (via `gh issue edit`).

## 🛠️ Fluxo de Trabalho Obrigatório
Nenhuma tarefa (Story/Epic) deve ser movida ou concluída sem passar por este ciclo estrito:
1. **Refinar (Discovery/Planejamento):** Discussão técnica, definição de parâmetros e validação de requisitos. **Nesta fase, as sub-tarefas técnicas devem ser explicitamente listadas na Issue antes de mover para Ready for Development.**
2. **Desenvolver:** Escrita do código, manifestos ou scripts. (Move para `In Progress`).
3. **Testar:** Validação técnica empírica do que foi desenvolvido (logs, status de pods, conectividade local). A IA deve confirmar sucesso antes de prosseguir.
4. **Deploy/Commit:** Persistência no repositório Git. Somente após o commit a tarefa deve ser movida para `Done` e fechada.

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
- `scripts/`: Scripts modulares acionados pelo Makefile.

---
*Este arquivo é uma bússola para o comportamento da IA neste projeto. As diretrizes aqui contidas têm precedência absoluta sobre quaisquer instruções genéricas.*