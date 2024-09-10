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
    for_each = local.has_eks_admin_role ? [1] : [0]
    content {
      role_arn     = var.eks_admin_role_arn
      session_name = var.aws_session_name
    }
  }

}
