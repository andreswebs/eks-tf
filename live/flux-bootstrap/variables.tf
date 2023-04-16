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

variable "flux_github_token" {
  type        = string
  description = "GitHub token"
  sensitive   = true
}
