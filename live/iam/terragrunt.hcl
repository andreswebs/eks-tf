include {
  path = find_in_parent_folders()
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

inputs = {
  aws_region  = local.config.aws_region
  eks_admin_role_name = local.config.eks_admin_role_name
}
