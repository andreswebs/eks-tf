output "role_arn" {
  value = {
    cert_manager = module.cert_manager.iam_role.arn
  }
}
