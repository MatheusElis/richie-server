# Instruction Context for Richie Homelab

This file provides foundational instructions and architectural context for interacting with the Richie Homelab codebase. All future interactions must adhere to the patterns and standards described here.

## Project Overview
Richie Homelab is a professional-grade personal infrastructure project managed via GitOps. It uses **k3s** as the Kubernetes orchestrator and **ArgoCD** for continuous deployment. The project follows the **App of Apps** pattern, where each application is represented as an individual card in ArgoCD for granular tracking and health monitoring.

### Main Technologies
- **Orchestration:** k3s (Single Node)
- **GitOps:** ArgoCD
- **Ingress Controller:** Traefik
- **Certificate Management:** cert-manager (Self-signed CA for local HTTPS)
- **Database:** Centralized PostgreSQL 15
- **Automation:** Makefile & Bash scripts
- **Operating System:** Fedora Server

## Directory Structure
- `Makefile`: Entry point for all lifecycle operations.
- `bootstrap/`: Orchestration scripts for OS preparation, k3s installation, and ArgoCD bootstrap.
- `clusters/`: ArgoCD root and individual Application definitions.
    - `apps/`: One YAML per user application.
    - `infra/`: One YAML per infrastructure component.
- `apps/`: Implementation of user services.
    - `[app-name]/`: Contains a **consolidated YAML** manifest for the application.
    - `shared-storage/`: Definitions for persistent volumes shared across multiple pods (Media, Downloads).
- `infra/`: Implementation of base components (PostgreSQL, namespaces, ingress routes).

## Automation & Commands
The project uses a `Makefile` to simplify complex operations:
- `make install`: Full end-to-end setup (OS prep -> k3s -> Auth -> ArgoCD -> Tests).
- `make teardown`: Complete destructive reset (removes k3s and all data in `/home/elis/data`).
- `make test`: Validates all application endpoints via `curl`.
- `make setup-auth`: Generates the `homelab-auth` Secret in `infra` and `apps` namespaces using credentials from `bootstrap/.env`.

## Development Conventions

### 1. App of Apps Pattern
To add or modify an application, ensure there is:
1.  An `Application` manifest in `clusters/apps/` pointing to the application source path.
2.  A corresponding directory in `apps/`.

### 2. Consolidated Manifests
Each application must manage its own lifecycle within a single file located at `apps/[app-name]/[app-name].yaml`. This file **must** include:
- `PersistentVolume` (using `hostPath` to `/home/elis/data/configs/[app-name]`).
- `PersistentVolumeClaim`.
- `Deployment`.
- `Service`.
- `Ingress` (with `cert-manager` annotations for local HTTPS).

### 3. Centralized Authentication
- Use the `homelab-auth` Secret for all services requiring a common username and password.
- Reference it in manifests using `valueFrom.secretKeyRef`.
- Current global credentials: User and Password are defined in `bootstrap/.env`.

### 4. Storage & Permissions
- **Base path:** `/home/elis/data`.
- **Media/Downloads:** Owned by UID:GID `1000:1000`.
- **Database (Postgres):** Owned by UID:GID `999:999`.
- **Nextcloud Data:** Owned by UID:GID `33:33`.

### 5. Networking
- **Host:** `192.168.31.55`.
- **Domain:** `*.cusin-server.duckdns.org`.
- **Protocol:** Always use HTTPS via Traefik Ingress. Applications should generally run in HTTP mode internally (use `--insecure` for ArgoCD).

## Operational Guidelines
- **GitOps First:** Always commit and push changes to the `main` branch. ArgoCD will automatically sync the cluster state.
- **Validation:** Always run `make test` after structural changes.
- **Cleanup:** For a clean state, use `make teardown` followed by `make install`.

- **Cleanup:** For a clean state, use `make teardown` followed by `make install`.
