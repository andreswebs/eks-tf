data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

locals {

  is_eks = var.eks_cluster_name != null && var.eks_cluster_name != ""

  private_subnet_tags = local.is_eks ? {
    "kubernetes.io/role/internal-elb"               = 1
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  } : null

  public_subnet_tags = local.is_eks ? {
    "kubernetes.io/role/elb"                        = 1
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  } : null

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1"

  name                 = var.network_name
  cidr                 = var.network_cidr
  azs                  = local.azs
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  private_subnet_tags = local.private_subnet_tags
  public_subnet_tags  = local.public_subnet_tags

}
