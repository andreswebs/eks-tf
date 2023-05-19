variable "eks_admin_role_arn" {
  type = string
}

variable "eks_cluster_name" {
  type = string
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

variable "flux_github_app_id" {
  type        = string
  description = "GitHub App ID"
  sensitive   = true
}

variable "flux_github_app_installation_id" {
  type        = string
  description = "GitHub App installation ID"
  sensitive   = true
}

variable "flux_github_app_private_key" {
  type        = string
  description = "GitHub App private key"
  sensitive   = true
}
