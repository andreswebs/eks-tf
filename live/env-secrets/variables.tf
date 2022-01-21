variable "github_token_secret" {
  type        = string
  description = "Name of a secret in AWS Secrets Manager storing a GitHub access token"
  default     = "github-token"
}
