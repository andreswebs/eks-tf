module "iam" {
  source               = "../../modules/iam"
  eks_worker_role_name = "${var.eks_cluster_name}-node"
}

module "network" {
  source           = "../../modules/network"
  network_name     = var.network_name
  eks_cluster_name = var.eks_cluster_name
}

module "eks" {
  source              = "../../modules/eks"
  eks_cluster_name    = var.eks_cluster_name
  eks_cluster_version = "1.30"
  vpc_id              = module.network.vpc_id
  private_subnets     = module.network.private_subnet_ids

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
}
