data "aws_secretsmanager_secret_version" "github_token_secret" {
  secret_id = var.github_token_secret
}
