resource "random_id" "id" {
  byte_length = 8
}

resource "aws_s3_bucket" "loki_storage" {
  bucket = "loki-storage-${random_id.id.hex}"
  acl    = "private"

  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "loki_storage" {

  bucket = aws_s3_bucket.loki_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "bucket_crud" {

  statement {
    sid = "AllowListObjects"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.loki_storage.id}"
    ]
  }

  statement {
    sid = "AllowObjectsCRUD"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.loki_storage.id}/*"
    ]
  }

}

module "loki_assume_role_policy" {
  source                = "../k8s-assume-role-policy"
  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_sa_name           = var.loki_service_account_name
  k8s_sa_namespace      = local.monitoring_namespace
}

resource "aws_iam_role" "loki" {
  name                  = "loki"
  assume_role_policy    = module.loki_assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "loki_permissions" {
  name   = "loki-permissions"
  role   = aws_iam_role.loki.id
  policy = data.aws_iam_policy_document.bucket_crud.json
}

module "loki_compactor_assume_role_policy" {
  source                = "../k8s-assume-role-policy"
  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_sa_name           = var.loki_compactor_service_account_name
  k8s_sa_namespace      = local.monitoring_namespace
}

resource "aws_iam_role" "loki_compactor" {
  name                  = "loki-compactor"
  assume_role_policy    = module.loki_compactor_assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "loki_compactor_permissions" {
  name   = "loki-compactor-permissions"
  role   = aws_iam_role.loki_compactor.id
  policy = data.aws_iam_policy_document.bucket_crud.json
}
