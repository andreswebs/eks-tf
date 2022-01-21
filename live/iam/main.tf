data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_admin" {

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


module "s3-requisites-for-ssm-policy-document" {
  source  = "andreswebs/s3-requisites-for-ssm-policy-document/aws"
  version = "1.0.0"
}

data "aws_iam_policy_document" "ecr_push" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "eks_admin" {
  name                = var.eks_admin_role_name
  assume_role_policy  = data.aws_iam_policy_document.eks_admin.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_policy" "s3_requisites_for_ssm" {
  name        = "s3-requisites-for-ssm"
  description = "Access to S3 buckets required for SSM"
  policy      = module.s3_requisites_for_ssm.json
}

resource "aws_iam_policy" "ecr_push" {
  name        = "ecr-push"
  description = "Allow push images to ECR"
  policy      = data.aws_iam_policy_document.ecr_push.json
}

