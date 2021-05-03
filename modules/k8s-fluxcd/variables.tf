variable "namespace" {
  type        = string
  default     = "flux-system"
  description = "Name of a namespace which will be created for deploying the resources"
}

variable "repository_name" {
  type = string
  description = "Name of an existing Git repository to store the FluxCD manifests"
}

variable "target_path" {
  type = string
  default = "flux"
  description = "Target path for storing FluxCD manifests in the Git repository"
}

variable "git_branch" {
  type = string
  default = "main"
  description = "Git branch"
}

variable "github_owner" {
  type        = string
  description = "GitHub owner"
}

# variable "github_token" {
#   type        = string
#   description = "GitHub token"
# }

variable "github_deploy_key_title" {
  type = string
  default = "flux-key"
  description = "GitHub deploy key title"
}
