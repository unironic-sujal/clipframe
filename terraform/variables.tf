variable "cluster_name" {
  description = "Name of the Kind Kubernetes cluster"
  type        = string
  default     = "clipframe-local"
}

variable "environment" {
  description = "Deployment environment label"
  type        = string
  default     = "development"
}

variable "local_port" {
  description = "Local port to forward to the cluster (access app at http://localhost:<port>)"
  type        = number
  default     = 8080
}
