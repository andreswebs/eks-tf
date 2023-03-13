include {
  path = find_in_parent_folders()
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

inputs = {
  aws_region  = local.config.aws_region
  eks_admin_role_name = lookup(local.config, "eks_admin_role_name", "${local.config.eks_cluster_name}-eks-admin")
  eks_worker_role_name = lookup(local.config, "eks_worker_role_name", "${local.config.eks_cluster_name}-eks-worker-node")
  create_eks_admin_role = lookup(local.config, "create_eks_admin_role", true)
}
