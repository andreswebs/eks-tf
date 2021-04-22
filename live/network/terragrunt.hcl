include {
  path = find_in_parent_folders()
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

inputs = {
  aws_region  = local.config.aws_region
  network_name = local.config.network_name
  eks_cluster_name = local.config.eks_cluster_name
}
