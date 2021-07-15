/**
* # iam-policy-document-access-secrets
*
* Generates an IAM policy document with permissons to access a specifically named secret
* from Secrets Manager.
*
*/

terraform {
  required_version = ">= 1.0.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "3.46.0"
    }

  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  secret_arns = [for s in var.secret_names : "arn:${data.aws_partition.current.partition}:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${s}-??????"]
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "AccessSecret"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = local.secret_arns
  }
}
