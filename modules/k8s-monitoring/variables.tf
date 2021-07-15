variable "namespace" {
  type        = string
  description = "Name of a namespace which will be created for deploying the resources"
  default     = "monitoring"
}

variable "cert_arn" {
  type        = string
  description = "ARN of TLS certificate from AWS Certificate Manager"
  default     = ""
}

variable "cluster_oidc_provider" {
  type        = string
  description = "OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster"
  default     = ""
}

variable "loki_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for Loki components"
  default     = "loki-distributed"
}

variable "loki_compactor_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for the Loki compactor"
  default     = "loki-compactor"
}

variable "grafana_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for Grafana"
  default     = "grafana"
}
