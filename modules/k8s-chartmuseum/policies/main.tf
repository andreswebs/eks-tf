terraform {
  required_version = ">= 1.0.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.46.0"
    }
  }
}

data "aws_partition" "current" {}

locals {
  s3_bucket_arn = "arn:aws:${data.aws_partition.current.partition}:s3:::${var.s3_bucket_name}"
}

data "aws_iam_policy_document" "storage_read" {

  statement {
    sid = "AllowRead"
    actions = [
      "s3:List*",
      "s3:Get*"
    ]
    resources = [
      local.s3_bucket_arn,
      "${local.s3_bucket_arn}/*"
    ]
  }

}

resource "aws_iam_policy" "storage_read" {
  name        = "chartmuseum-readonly"
  policy      = data.aws_iam_policy_document.storage_read.json
  description = "Allow read-only access to Chartmuseum storage bucket"
}

data "aws_iam_policy_document" "storage_readwrite" {
  source_json = data.aws_iam_policy_document.storage_read.json
  statement {
    sid = "AllowWrite"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject"
    ]
    resources = ["${local.s3_bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "storage_readwrite" {
  name        = "chartmuseum-readwrite"
  description = "Allows read and write access to Chartmuseum storage bucket"
  policy      = data.aws_iam_policy_document.storage_readwrite.json
}
