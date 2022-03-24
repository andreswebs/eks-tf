data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  key_alias = "alias/${var.kms_key_name}"
  root_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}

data "aws_iam_policy_document" "key_policy" {

  statement {
    sid       = "IAMUserPermissions"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = [local.root_arn]
    }
  }

  statement {
    sid = "PermissionsViaEC2"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "ec2.${data.aws_region.current.name}.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

}

resource "aws_kms_key" "ebs_default" {
  description         = "Default EBS encryption key"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.key_policy.json
}

resource "aws_kms_alias" "ebs_default" {
  name          = local.key_alias
  target_key_id = aws_kms_key.ebs_default.key_id
}

resource "aws_ebs_default_kms_key" "this" {
  key_arn = aws_kms_key.ebs_default.arn
}

resource "aws_ebs_encryption_by_default" "this" {
  enabled = true
}
