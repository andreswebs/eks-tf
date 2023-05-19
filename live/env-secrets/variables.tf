variable "github_app_secret" {
  type        = string
  description = "Name of a secret in AWS Secrets Manager storing GitHub App credentials"
  default     = "github-app"
}
