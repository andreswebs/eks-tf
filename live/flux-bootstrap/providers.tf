variable "aws_region" {
  type    = string
  default = "us-east-1"
}

locals {
  has_eks_admin_role = var.eks_admin_role_arn != null && var.eks_admin_role_arn != ""
}

provider "aws" {

  region = var.aws_region

  dynamic "assume_role" {
    for_each = local.has_eks_admin_role ? [] : [1]
    content {
      role_arn     = var.eks_admin_role_arn
      session_name = "terraform"
    }
  }

}

data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
  }
}


provider "github" {
  owner = var.flux_github_owner
  token = var.flux_github_token
}

provider "flux" {}
