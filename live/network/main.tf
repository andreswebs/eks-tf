provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                   = "terraform-aws-modules/vpc/aws"
  version                  = "2.77.0"
  name                     = var.network_name
  cidr                     = "10.0.8.0/21"
  azs                      = ["us-east-1a", "us-east-1b", "us-east-1b"]
  private_subnets          = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
  public_subnets           = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  enable_nat_gateway       = true
  single_nat_gateway       = true
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"               = 1
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"                        = 1
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }

}
