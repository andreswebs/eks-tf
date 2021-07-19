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

module "chartmuseum_iam" {
  source         = "./modules/policies"
  s3_bucket_name = var.s3_bucket_name
}

module "chartmuseum_resources" {
  source                    = "./modules/resources"
  chartmuseum_chart_version = local.chart_versions["chartmuseum"]
  storage_access_policy_arn = module.chartmuseum_iam.policy.storage_read.arn
  s3_bucket_name            = var.s3_bucket_name
  s3_object_key_prefix      = var.s3_object_key_prefix
  k8s_sa_name               = var.k8s_sa_name
  k8s_namespace             = var.k8s_namespace
  cluster_oidc_provider     = var.cluster_oidc_provider
}
