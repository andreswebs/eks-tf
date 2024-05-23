output "role_arn" {
  value = {
    cert_manager     = module.cert_manager.iam_role.arn
    external_secrets = module.external_secrets.iam_role.arn
  }
}
