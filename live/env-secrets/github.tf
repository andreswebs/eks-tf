data "aws_secretsmanager_secret_version" "github_app_secret" {
  secret_id = var.github_app_secret
}

/*
  Note:

  This configuration expects the secret to be a JSON with the following properties,
  where all the values are base64-encoded strings:

  {
    "github_app_id_base64": "...",
    "github_app_installation_id_base64": "...",
    "github_app_private_key_base64": "...",
  }

*/

locals {
  github_app_secret = jsondecode(data.aws_secretsmanager_secret_version.github_app_secret.secret_string)
}

output "github_app_id" {
  value     = base64decode(local.github_app_secret.github_app_id_base64)
  sensitive = true
}

output "github_app_installation_id" {
  value     = base64decode(local.github_app_secret.github_app_installation_id_base64)
  sensitive = true
}

output "github_app_private_key" {
  value     = base64decode(local.github_app_secret.github_app_private_key_base64)
  sensitive = true
}
