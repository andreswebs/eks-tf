output "github_token" {
  value     = data.aws_secretsmanager_secret_version.github_token_secret.secret_string
  sensitive = true
}
