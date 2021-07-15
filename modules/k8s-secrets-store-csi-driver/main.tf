/**
* # k8s-aws-secrets-store-csi-driver
*
* Deploys the Kubernets CSI Secrets Store Driver and the AWS Secrets Manager and Config Provider for the driver
*
* ## References
*
* <https://secrets-store-csi-driver.sigs.k8s.io>
*
* <https://github.com/aws/secrets-store-csi-driver-provider-aws>
*
*/

terraform {
  required_version = ">= 1.0.0"

  required_providers {

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

data "aws_region" "current" {}

locals {
  name      = "secrets-store-csi-driver"
  namespace = "kube-system"
  chart_versions = {
    secrets_store_csi_driver = "0.0.22"
  }
}

resource "helm_release" "secrets_store_csi_driver" {
  name       = local.name
  namespace  = local.namespace
  repository = "https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/master/charts"
  chart      = "secrets-store-csi-driver"
  version    = local.chart_versions["secrets_store_csi_driver"]

  recreate_pods   = true
  reuse_values    = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2

  set {
    name  = "enableSecretRotation"
    value = var.enable_secret_rotation
  }

  set {
    name  = "syncSecret.enabled"
    value = var.enable_secret_sync
  }

  set {
    name  = "rotationPollInterval"
    value = var.rotation_poll_interval
  }

}
