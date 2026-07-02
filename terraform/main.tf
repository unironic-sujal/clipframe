# ──────────────────────────────────────────────────────────────
# ClipFrame — Terraform (Local Kind Cluster)
# Provisions a local Kubernetes cluster using `kind` for
# development and demo purposes.
#
# Prerequisites:
#   - Docker installed and running
#   - kind installed: https://kind.sigs.k8s.io/
#   - kubectl installed
#
# Usage:
#   terraform init
#   terraform apply
# ──────────────────────────────────────────────────────────────

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
  }
}

# ── Kind cluster ────────────────────────────────────────────
resource "kind_cluster" "clipframe" {
  name           = var.cluster_name
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      # Port mapping: forward local 8080 → cluster port 80
      extra_port_mappings {
        container_port = 80
        host_port      = var.local_port
        listen_address = "127.0.0.1"   # Bind to localhost only (not 0.0.0.0)
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}

# ── Kubernetes provider — uses the kind cluster's kubeconfig ─
provider "kubernetes" {
  host                   = kind_cluster.clipframe.endpoint
  cluster_ca_certificate = kind_cluster.clipframe.cluster_ca_certificate
  client_certificate     = kind_cluster.clipframe.client_certificate
  client_key             = kind_cluster.clipframe.client_key
}

# ── Namespace ────────────────────────────────────────────────
resource "kubernetes_namespace" "clipframe" {
  depends_on = [kind_cluster.clipframe]

  metadata {
    name = "clipframe"
    labels = {
      app         = "clipframe"
      managed-by  = "terraform"
      environment = var.environment
    }
  }
}

# ── Apply K8s manifests via kubectl ─────────────────────────
# (After namespace is created, the CD pipeline applies the rest)
resource "null_resource" "apply_manifests" {
  depends_on = [kubernetes_namespace.clipframe]

  provisioner "local-exec" {
    command = <<-EOF
      KUBECONFIG="${kind_cluster.clipframe.kubeconfig_path}" \
      kubectl apply -f ../k8s/configmap.yaml
    EOF
  }
}
