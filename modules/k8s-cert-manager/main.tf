/**
* # k8s-cert-manager
*
* Deploys [cert-manager](https://cert-manager.io).
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

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.namespace
  }
}

locals {
  cert_manager_namespace = kubernetes_namespace.cert_manager.metadata[0].name
  chart_versions = {
    cert_manager = "v1.4.0"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = local.cert_manager_namespace
  version    = local.chart_versions["cert_manager"]

  recreate_pods   = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2

  values = [
    templatefile("${path.module}/helm-values/cert-manager.yml.tpl", {
      cert_manager_service_account_name = var.cert_manager_service_account_name
      cert_manager_iam_role_arn         = aws_iam_role.cert_manager.arn
    })
  ]

}
