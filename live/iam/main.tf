data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_admin" {

  count = var.create_eks_admin_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/eks-admin"
      values   = ["true"]
    }

  }
}

resource "aws_iam_role" "eks_admin" {
  count               = var.create_eks_admin_role ? 1 : 0
  name                = var.eks_admin_role_name
  assume_role_policy  = data.aws_iam_policy_document.eks_admin[0].json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

module "eks_worker" {
  source       = "andreswebs/ec2-role/aws"
  version      = "1.0.0"
  role_name    = var.eks_worker_role_name
  profile_name = var.eks_worker_role_name
  policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ]
  tags = {
    eks-worker = "true"
  }
}

module "s3_requisites_for_ssm" {
  source  = "andreswebs/s3-requisites-for-ssm-policy-document/aws"
  version = "1.0.0"
}

resource "aws_iam_role_policy" "eks_worker_s3_requisites_for_ssm" {
  name   = "s3-requisites-for-ssm"
  role   = module.eks_worker.role.id
  policy = module.s3_requisites_for_ssm.json
}
