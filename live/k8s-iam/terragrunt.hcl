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

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

inputs = {
  aws_region = local.config.aws_region
  eks_admin_role_arn = dependency.iam.outputs.role_arn.eks_admin
  eks_cluster_name = dependency.k8s.outputs.cluster_name
  external_secrets_names = local.config.external_secrets_names
}
