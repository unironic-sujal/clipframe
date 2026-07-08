# ClipFrame 🎬

> Extract any frame from any video as a full-quality, **lossless PNG** — no quality loss, no screenshots, no black borders.

**Live:** [clipframe-mu.vercel.app](https://clipframe-mu.vercel.app)

---

## What It Does

Load any local video file (MP4, MOV, WebM, MKV, AVI — 4K, 8K, 60fps, anything), scrub to the exact frame you want, and save it as a pixel-perfect PNG at the video's native resolution.

No uploads. No server. Runs entirely in your browser. Your video never leaves your machine.

---

## Features

- 🎞️ **Lossless PNG export** at native video resolution (3840×2160 for 4K)
- ⏱️ **Frame-accurate seeking** — step frame by frame using keyboard or buttons
- 🔍 **Auto FPS detection** — uses `requestVideoFrameCallback` to detect native framerate
- 🎬 **Filmstrip thumbnail strip** — visual scrubbing through the video
- ⌨️ **Keyboard shortcuts** — Space, ←→, Shift+←→, S, C
- 📋 **Copy to clipboard** — paste directly into any app
- 🎚️ **Playback speed control** — 0.25×, 0.5×, 1×, 1.5×, 2×
- 📱 **PWA support** — installable, works offline via service worker
- 📱 **Fully responsive** — works on mobile + desktop
- 🔒 **100% private** — no uploads, videos never leave your machine
- 📊 **Vercel Web Analytics** — privacy-friendly, cookie-free usage analytics

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

> **Note:** For the filmstrip and full feature support, serve via a local HTTP server (not `file://` protocol).

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

This project demonstrates a full production-grade DevOps pipeline, built as a portfolio showcase.

| Tool | Purpose |
|---|---|
| **Docker** | Multi-stage build → `nginx:alpine` image (~25MB) |
| **Docker Compose** | Local development with health checks |
| **GitHub Actions** | CI/CD pipeline (validate → build → deploy) |
| **Kubernetes** | Deployment, Service, Ingress, HPA, ConfigMap |
| **Terraform** | Provision local Kind cluster + kubeconfig |
| **Ansible** | Bootstrap any fresh machine with all dependencies |
| **Vercel** | Public hosting with global CDN + analytics |

### CI/CD Pipeline

```
Push to any branch   → CI: validate HTML/JS security + Docker build + health check + header verification
Push to main branch  → CD: build → push to DockerHub → deploy to K8s
Merge to master      → Vercel auto-deploys to production
```

**CI checks include:**
- No `innerHTML` usage (XSS prevention)
- CSP enforced via HTTP headers (`vercel.json` / `nginx.conf`)
- No hardcoded secrets in source
- Docker image builds successfully
- Container health check passes (`/health` endpoint)
- Security headers present in HTTP response

### Kubernetes (local with Kind)

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

### Bootstrap a Fresh Machine with Ansible

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
# Installs: Docker, kubectl, Kind, Terraform
```

---

## Security

- **No `innerHTML`** — all DOM manipulation via `createElement` / `textContent`
- **Content Security Policy (CSP)** enforced via HTTP response headers in `vercel.json` and `nginx.conf`
  - `script-src 'self'` — only first-party scripts
  - `connect-src 'self'` + Vercel Analytics endpoints
  - `object-src 'none'` — no plugins
  - `frame-ancestors 'none'` — prevents clickjacking
- **Security headers:** `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Strict-Transport-Security`, `Permissions-Policy`, `Referrer-Policy`
- **Filename sanitization** before use in download attribute
- **Object URLs revoked** after use (no memory leaks)
- **Videos stay local** — zero server contact, zero data exfiltration

---

## Project Structure

```
clipframe/
├── index.html            # App shell
├── style.css             # Design system
├── app.js                # Core logic (frame extraction, filmstrip, FPS detection)
├── sw.js                 # Service worker (PWA offline support)
├── manifest.json         # PWA manifest
├── nginx.conf            # Production web server config with security headers
├── Dockerfile            # Multi-stage container build (node → nginx:alpine)
├── docker-compose.yml    # Local dev with health checks
├── vercel.json           # Vercel deployment config + security headers
├── package.json          # Dependencies (@vercel/analytics)
├── .dockerignore         # Docker build exclusions
├── .gitignore            # Git exclusions
├── .github/
│   └── workflows/
│       ├── ci.yml        # CI: validate + Docker build + health check
│       └── cd.yml        # CD: push to DockerHub + deploy to K8s
├── k8s/
│   ├── namespace.yaml    # clipframe namespace
│   ├── configmap.yaml    # Nginx config for K8s
│   ├── deployment.yaml   # 2 replicas, resource limits, health probes
│   ├── service.yaml      # ClusterIP service
│   └── ingress.yaml      # Ingress with TLS
├── terraform/
│   ├── main.tf           # Kind cluster + kubeconfig provider
│   ├── variables.tf      # Cluster name, K8s version, node count
│   └── outputs.tf        # Kubeconfig path, cluster name
└── ansible/
    ├── playbook.yml      # Full machine bootstrap (Docker, kubectl, Kind, Terraform)
    └── inventory.ini     # Target hosts
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | Vanilla HTML, CSS, JavaScript (zero dependencies) |
| **Server** | Nginx Alpine (production), Vercel (public CDN) |
| **Containerisation** | Docker multi-stage build |
| **Orchestration** | Kubernetes (Kind for local) |
| **Infrastructure** | Terraform (IaC) |
| **Configuration** | Ansible (machine bootstrap) |
| **CI/CD** | GitHub Actions |
| **Hosting** | Vercel (auto-deploy on push) |
| **Analytics** | Vercel Web Analytics (privacy-friendly, no cookies) |

---

## Built By

**Sujal Patel** — [GitHub](https://github.com/unironic-sujal) · [LinkedIn](https://linkedin.com/in/sujalpatel31)
