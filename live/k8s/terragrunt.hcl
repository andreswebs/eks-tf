include {
  path = find_in_parent_folders()
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

dependency "network" {
  config_path = "${path_relative_from_include()}/network"
}

dependency "iam" {
  config_path = "${path_relative_from_include()}/iam"
}

dependency "ec2_key_pair" {
  config_path = "${path_relative_from_include()}/ec2-key-pair"
}

inputs = {
  aws_region = local.config.aws_region
  eks_cluster_name = local.config.eks_cluster_name
  eks_cluster_version = local.config.eks_cluster_version
  eks_admin_role_arn = dependency.iam.outputs.role_arn.eks_admin
  eks_worker_profile_name = dependency.iam.outputs.profile_name.eks_worker
  ssh_key_name = dependency.ec2_key_pair.outputs.key_name
  vpc_id = dependency.network.outputs.vpc_id
  private_subnets = dependency.network.outputs.private_subnets
  public_subnets = dependency.network.outputs.public_subnets
}

terraform {
  before_hook "remove_aws_auth" {
    commands     = ["destroy"]
    execute      = ["terraform", "state", "rm", "module.eks.kubernetes_config_map.aws_auth"]
    run_on_error = false
  }
}
