module "iam" {
  source = "../../modules/iam"
  # eks_worker_role_name = "${var.eks_cluster_name}-node"
  create_eks_admin_role = true
}

module "eks" {
  source              = "../../modules/eks"
  eks_cluster_name    = var.eks_cluster_name
  eks_cluster_version = "1.30"
  vpc_id              = var.vpc_id
  private_subnets     = var.private_subnets

  eks_worker_role_arn    = module.iam.eks_worker_role_arn
  whitelisted_cidrs_ipv4 = var.whitelisted_cidrs_ipv4
}
