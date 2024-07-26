data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

locals {

  private_subnet_tags = merge(var.private_subnet_tags, {
    "kubernetes.io/role/internal-elb" = 1
  })

  public_subnet_tags = merge(var.public_subnet_tags, {
    "kubernetes.io/role/elb" = 1
  })

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
  single_nat_gateway   = var.single_nat_gateway

  private_subnet_tags = local.private_subnet_tags
  public_subnet_tags  = local.public_subnet_tags

}
