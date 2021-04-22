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
  eks_cluster_id = dependency.k8s.outputs.cluster_id
  route53_zone_id = dependency.route53.outputs.zone_id
  route53_zone_name = dependency.route53.outputs.zone_name
  k8s_monitoring_namespace = local.config.k8s_monitoring_namespace
}
