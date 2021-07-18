/**
* # k8s-chartmuseum
*
* Deploys [chartmuseum](https://chartmuseum.com).
*
*/

terraform {
  required_version = ">= 1.0.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.46.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.3.2"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.2.0"
    }

  }
}

locals {

  chart_versions = {
    chartmuseum = "3.1.0"
  }

}

data "aws_region" "current" {}

module "k8s_assume_role_policy" {
  source                = "../k8s-assume-role-policy"
  k8s_sa_name           = var.k8s_sa_name
  k8s_sa_namespace      = var.k8s_namespace
  cluster_oidc_provider = var.cluster_oidc_provider
}

resource "aws_iam_role" "chartmuseum" {
  name               = "chartmuseum"
  assume_role_policy = module.k8s_assume_role_policy.json
}

module "chartmuseum_iam" {
  source         = "./policies"
  s3_bucket_name = var.s3_bucket_name
}

resource "aws_iam_role_policy_attachment" "storage_read" {
  policy_arn = module.chartmuseum_iam.policy.storage_read.arn
  role       = aws_iam_role.chartmuseum.id
}

resource "helm_release" "chartmuseum" {

  name       = "chartmuseum"
  namespace  = var.k8s_namespace
  repository = "https://chartmuseum.github.io/charts"
  chart      = "chartmuseum"
  version    = local.chart_versions["chartmuseum"]

  recreate_pods   = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 900
  max_history     = 2

  values = [
    templatefile("${path.module}/helm-values/chartmuseum.yml.tpl", {
      aws_region           = data.aws_region.current.name
      s3_bucket_name       = var.s3_bucket_name
      s3_object_key_prefix = var.s3_object_key_prefix
      k8s_sa_name          = var.k8s_sa_name
      iam_role_arn         = aws_iam_role.chartmuseum.arn
    })
  ]

}

