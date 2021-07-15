/**
 * # k8s-elasticsearch
 *
 * Deploys the elastic stack in a namespace in Kubernetes
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

resource "kubernetes_namespace" "elastic" {
  metadata {
    name = var.namespace
  }
}

locals {
  elastic_namespace = kubernetes_namespace.elastic.metadata[0].name
  chart_versions = {
    elasticsearch = "7.13.2"
    kibana        = "7.13.2"
  }
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = local.elastic_namespace
  version    = local.chart_versions["elasticsearch"]

  recreate_pods   = true
  reuse_values    = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2

}

resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  namespace  = local.elastic_namespace
  version    = local.chart_versions["kibana"]

  recreate_pods   = true
  reuse_values    = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2

}
