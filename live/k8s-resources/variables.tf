variable "eks_admin_role_arn" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "k8s_monitoring_namespace" {
  type    = string
  default = "monitoring"
}

variable "flux_repository_name" {
  type = string
}

variable "flux_git_branch" {
  type    = string
  default = "main"
}

variable "flux_github_owner" {
  type        = string
  description = "GitHub owner"
}

variable "flux_github_token" {
  type        = string
  description = "GitHub token"
  sensitive   = true
}

variable "chartmuseum_s3_bucket_name" {
  type        = string
  description = "S3 bucket for chartmuseum storage"
}

variable "chartmuseum_s3_object_key_prefix" {
  type        = string
  description = "Prefix for chart names in S3"
  default     = "charts/"
}
