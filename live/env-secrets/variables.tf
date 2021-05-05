variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "github_token_secret" {
  type = string
  description = "Name of a secret in AWS Secrets Manager storing a GitHub access token"
  default = "github-token"
}
