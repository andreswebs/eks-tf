data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  partition  = data.aws_partition.current.partition
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "eks_admin" {

  count = var.create_eks_admin_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [local.account_id]
    }

    dynamic "condition" {
      for_each = var.eks_admin_role_enable_tag_condition ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:PrincipalTag/${var.eks_admin_role_tag_key}"
        values   = [var.eks_admin_role_tag_value]
      }
    }
  }
}

resource "aws_iam_role" "eks_admin" {
  count               = var.create_eks_admin_role ? 1 : 0
  name                = var.eks_admin_role_name
  assume_role_policy  = data.aws_iam_policy_document.eks_admin[0].json
  managed_policy_arns = ["arn:${local.partition}:iam::aws:policy/AdministratorAccess"]
}

module "eks_worker" {
  count        = var.create_eks_worker_role ? 1 : 0
  source       = "andreswebs/ec2-role/aws"
  version      = "1.1.0"
  role_name    = var.eks_worker_role_name
  profile_name = var.eks_worker_role_name
  policies = [
    "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:${local.partition}:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:${local.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:${local.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:${local.partition}:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:${local.partition}:iam::aws:policy/AWSAppMeshEnvoyAccess",
  ]
}

module "s3_requisites_for_ssm" {
  count   = var.create_eks_worker_role ? 1 : 0
  source  = "andreswebs/s3-requisites-for-ssm-policy-document/aws"
  version = "1.1.0"
}

resource "aws_iam_role_policy" "eks_worker_s3_requisites_for_ssm" {
  count  = var.create_eks_worker_role ? 1 : 0
  name   = "s3-requisites-for-ssm"
  role   = module.eks_worker[0].role.id
  policy = module.s3_requisites_for_ssm[0].json
}
