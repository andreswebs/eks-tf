variable "chartmuseum_chart_version" {
  type        = string
  description = "Chartmuseum Helm chart version"
  default     = null
}

variable "storage_access_policy_arn" {
  type        = string
  description = "ARN of the IAM policy that allows access to the Chartmuseum storage bucket"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket for chart storage"
}

variable "s3_object_key_prefix" {
  type        = string
  description = "Prefix added to S3 object names"
  default     = null
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace on which to install Chartmuseum"
}

variable "k8s_sa_name" {
  type        = string
  description = "Name of the Kubernetes service account used by Chartmuseum"
  default     = "chartmuseum"
}

variable "cluster_oidc_provider" {
  type        = string
  description = "OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster"
}
