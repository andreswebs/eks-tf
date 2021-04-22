variable "cluster_oidc_provider" {
  type        = string
  description = "OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}
