include {
  path = find_in_parent_folders()
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

inputs = {
  aws_region  = local.config.aws_region
  ssh_key_name = local.config.ssh_key_name
  ssm_parameter_name = "/${local.config.eks_cluster_name}/ec2-key-pair"
}
