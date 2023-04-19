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

data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

locals {
  cluster_oidc_provider = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}
