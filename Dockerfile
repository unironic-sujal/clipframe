# ──────────────────────────────────────────────────────────────
# ClipFrame — Dockerfile
# Multi-stage build:
#   Stage 1 (builder): Validates and copies static assets
#   Stage 2 (runtime): nginx:alpine — minimal, secure image
# Final image is ~25MB.
# ──────────────────────────────────────────────────────────────

# ── Stage 1: Builder ─────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /build

# Copy application files
COPY index.html   .
COPY style.css    .
COPY app.js       .
COPY sw.js        .
COPY manifest.json .

# Optional: run any build-time validation or linting here
# e.g., npx html-validate index.html

# ── Stage 2: Runtime ─────────────────────────────────────────
FROM nginx:1.27-alpine AS runtime

LABEL org.opencontainers.image.title="ClipFrame" \
      org.opencontainers.image.description="Extract lossless frames from any video" \
      org.opencontainers.image.source="https://github.com/unironic-sujal/clipframe"

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built static files from builder stage
COPY --from=builder /build/ /usr/share/nginx/html/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Remove server version disclosure from nginx
RUN sed -i 's/^http {/http {\n    server_tokens off;/' /etc/nginx/nginx.conf

# Create non-root user for nginx worker processes
# (nginx master still runs as root to bind port 80, but workers run as nginx user)
RUN chown -R nginx:nginx /usr/share/nginx/html \
    && chmod -R 755 /usr/share/nginx/html

# Healthcheck used by Docker and orchestrators
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/health || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
