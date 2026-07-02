output "cluster_name" {
  description = "Name of the created Kind cluster"
  value       = kind_cluster.clipframe.name
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig file for this cluster"
  value       = kind_cluster.clipframe.kubeconfig_path
}

output "app_url" {
  description = "Local URL to access the ClipFrame app"
  value       = "http://localhost:${var.local_port}"
}

output "kubectl_command" {
  description = "kubectl command to use this cluster"
  value       = "export KUBECONFIG=${kind_cluster.clipframe.kubeconfig_path}"
}
