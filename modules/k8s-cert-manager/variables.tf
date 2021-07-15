variable "namespace" {
  type        = string
  description = "Name of a namespace which will be created for deploying the resources"
  default     = "cert-manager"
}

variable "cluster_oidc_provider" {
  type        = string
  description = "OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster"
  default     = ""
}

variable "cert_manager_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for cert-manager"
  default     = "cert-manager"
}
