include {
  path = find_in_parent_folders()
}

dependency "iam" {
  config_path = "${path_relative_from_include()}/iam"
}

dependency "k8s" {
  config_path = "${path_relative_from_include()}/k8s"
}

dependency "route53" {
  config_path = "${path_relative_from_include()}/route53"
}

dependency "env_secrets" {
  config_path = "${path_relative_from_include()}/env-secrets"
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

inputs = {
  aws_region = local.config.aws_region
  eks_admin_role_arn = dependency.iam.outputs.role_arn.eks_admin
  eks_cluster_name = dependency.k8s.outputs.cluster_name
  flux_repository_name = local.config.flux_repository_name
  flux_git_branch = local.config.flux_git_branch
  flux_github_owner = local.config.flux_github_owner
  flux_github_app_id = dependency.env_secrets.outputs.github_app_id
  flux_github_app_installation_id = dependency.env_secrets.outputs.github_app_installation_id
  flux_github_app_private_key = dependency.env_secrets.outputs.github_app_private_key
}
