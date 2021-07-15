/**
* # k8s-portworx
*
* Deploys [PX-Backup](https://backup.docs.portworx.com/) from [Portworx](https://docs.portworx.com/).
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

resource "kubernetes_namespace" "px_backup" {
  metadata {
    name = var.namespace
  }
}

locals {
  px_backup_namespace = kubernetes_namespace.px_backup.metadata[0].name
  chart_versions = {
    px_backup = "1.2.3"
  }
}

resource "helm_release" "px_backup" {
  name       = "px-backup"
  repository = "http://charts.portworx.io"
  chart      = "px-backup"
  namespace  = local.px_backup_namespace
  version    = local.chart_versions["px_backup"]

  recreate_pods   = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2

  values = [
    templatefile("${path.module}/helm-values/px-backup.yml.tpl", {
      storage_class_name = var.storage_class_name
    })
  ]

}
