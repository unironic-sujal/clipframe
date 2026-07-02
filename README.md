# ClipFrame 🎬

> Extract any frame from any video as a full-quality, **lossless PNG** — no quality loss, no screenshots, no black borders.

**Live:** [clipframe.app](https://clipframe.app) _(coming soon)_

---

## What it does

Load any local video file (MP4, MOV, WebM, MKV, AVI — 4K, 8K, 60fps, anything), scrub to the exact frame you want, and save it as a pixel-perfect PNG at the video's native resolution.

No uploads. No server. Runs entirely in your browser. Your video never leaves your machine.

---

## Features

- 🎞️ **Lossless PNG export** at native video resolution (3840×2160 for 4K)
- ⏱️ **Frame-accurate seeking** — step frame by frame using keyboard or buttons
- 🎬 **Filmstrip thumbnail strip** — visual scrubbing through the video
- ⌨️ **Keyboard shortcuts** — Space, ←→, Shift+←→, S, C
- 📋 **Copy to clipboard** — paste directly into any app
- 📱 **Fully responsive** — works on mobile + desktop
- 🔒 **100% private** — no uploads, no tracking, no server

---

## Keyboard Shortcuts

| Key | Action |
|---|---|
| `Space` | Play / Pause |
| `←` / `→` | Step 1 frame |
| `Shift + ←` / `→` | Step 10 frames |
| `S` | Save frame as PNG |
| `C` | Copy frame to clipboard |
| `Home` / `End` | Jump to start / end |

---

## Running Locally

### Option 1: Open directly in browser
Just open `index.html` in Chrome or Firefox. Done.

> **Note:** For the filmstrip and full feature support, serve via a local HTTP server (not file:// protocol).

### Option 2: Docker (recommended)

```bash
# Build and run
docker-compose up --build

# App available at http://localhost:8080
```

### Option 3: Docker without Compose

```bash
docker build -t clipframe .
docker run -p 8080:80 clipframe
```

---

## DevOps Stack

| Tool | Purpose |
|---|---|
| **Docker** | Multi-stage build → nginx:alpine image |
| **Docker Compose** | Local development |
| **GitHub Actions** | CI/CD pipeline |
| **Kubernetes** | Deployment, Service, Ingress, HPA, ConfigMap |
| **Terraform** | Provision local Kind cluster |
| **Ansible** | Bootstrap any fresh machine |
| **Vercel** | Public hosting (free, global CDN) |

### CI/CD Pipeline

```
Push to any branch   → CI: validate HTML/JS + Docker build + health check
Push to main branch  → CD: build → push to DockerHub → deploy to K8s
```

### Kubernetes (local with Minikube or Kind)

```bash
# Provision cluster with Terraform
cd terraform
terraform init
terraform apply

# Deploy the app
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml

# Check status
kubectl get pods -n clipframe
kubectl get svc  -n clipframe
```

### Bootstrap a fresh machine with Ansible

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
# Installs: Docker, kubectl, kind, Terraform
```

---

## Security

- No `innerHTML` anywhere — all DOM via `createElement` / `textContent`
- Content Security Policy (CSP) on both meta tag and HTTP headers
- `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Permissions-Policy`
- Filename sanitized before use in download attribute
- Object URLs revoked after use (no memory leaks)
- Videos stay local — zero server contact

---

## Project Structure

```
clipframe/
├── index.html          # App shell
├── style.css           # Design system
├── app.js              # Core logic
├── sw.js               # Service worker (PWA)
├── manifest.json       # PWA manifest
├── nginx.conf          # Web server config
├── Dockerfile          # Multi-stage container build
├── docker-compose.yml  # Local dev
├── vercel.json         # Vercel deployment config
├── .github/
│   └── workflows/
│       ├── ci.yml      # CI pipeline
│       └── cd.yml      # CD pipeline
├── k8s/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── ansible/
    ├── playbook.yml
    └── inventory.ini
```

---

## Built by

**Sujal Patel** — [GitHub](https://github.com/unironic-sujal) · [LinkedIn](https://linkedin.com/in/sujalpatel31)
