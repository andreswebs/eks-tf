/**
 * # k8s-monitoring
 *
 * Deploys the "Grafana + Prometheus + Loki" monitoring stack in a selected namespace in Kubernetes
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

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }

  }
}

data "aws_region" "current" {}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

## NOTE: change loki_svc if using the loki single-binary chart
## loki_svc = "loki.${local.monitoring_namespace}.svc.cluster.local:3100"
locals {
  monitoring_namespace = kubernetes_namespace.monitoring.metadata[0].name
  prom_svc             = "prometheus-server.${local.monitoring_namespace}.svc.cluster.local"
  loki_svc             = "loki-distributed-gateway.${local.monitoring_namespace}.svc.cluster.local"
  chart_versions = {
    prometheus       = "14.2.1"
    fluent_bit       = "2.3.0"
    promtail         = "3.6.0"
    grafana          = "6.13.1"
    loki             = "2.5.0"
    loki_distributed = "0.33.0"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = local.monitoring_namespace
  version    = local.chart_versions["prometheus"]

  recreate_pods   = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 900
  max_history     = 2

  values = [
    file("${path.module}/helm-values/prometheus.yml")
  ]

}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = local.monitoring_namespace
  version    = local.chart_versions["grafana"]

  recreate_pods   = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 900
  max_history     = 2

  values = [
    templatefile("${path.module}/helm-values/grafana.yml.tpl", {
      aws_region                   = data.aws_region.current.name
      prom_svc                     = local.prom_svc
      loki_svc                     = local.loki_svc
      cert_arn                     = var.cert_arn
      grafana_service_account_name = var.grafana_service_account_name
      grafana_iam_role_arn         = aws_iam_role.grafana.arn
    })
  ]

}

##
## For reference only - using the loki-distributed chart instead
##
# resource "helm_release" "loki" {
#   name       = "loki"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "loki"
#   namespace  = local.monitoring_namespace
#   version    = local.chart_versions["loki"]

#   recreate_pods   = true
#   atomic          = true
#   cleanup_on_fail = true
#   wait            = true
#   timeout         = 900
#   max_history     = 2

#   values = [
#     file("${path.module}/helm-values/loki.yml")
#   ]
# }

resource "helm_release" "loki_distributed" {
  name       = "loki-distributed"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-distributed"
  namespace  = local.monitoring_namespace
  version    = local.chart_versions["loki_distributed"]

  recreate_pods   = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 900
  max_history     = 2

  values = [
    templatefile("${path.module}/helm-values/loki-distributed.yml.tpl", {
      aws_region                          = data.aws_region.current.name
      bucket_name                         = aws_s3_bucket.loki_storage.id
      loki_iam_role_arn                   = aws_iam_role.loki.arn
      loki_service_account_name           = var.loki_service_account_name
      loki_compactor_iam_role_arn         = aws_iam_role.loki_compactor.arn
      loki_compactor_service_account_name = var.loki_compactor_service_account_name
    })
  ]
}

##
## For reference only - using Promtail instead
##
# resource "helm_release" "fluent_bit" {
#   name       = "fluent-bit"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "fluent-bit"
#   namespace  = local.monitoring_namespace
#   version    = local.chart_versions["fluent_bit"]

#   recreate_pods   = true
#   atomic          = true
#   cleanup_on_fail = true
#   wait            = true
#   timeout         = 900
#   max_history     = 2

#   values = [
#     templatefile("${path.module}/helm-values/fluent-bit.yml.tpl", {
#       loki_svc = replace(local.loki_svc, ":3100", "")
#     })
#   ]

# }

resource "helm_release" "promtail" {
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  namespace  = local.monitoring_namespace
  version    = local.chart_versions["promtail"]

  recreate_pods   = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 900
  max_history     = 2

  values = [
    templatefile("${path.module}/helm-values/promtail.yml.tpl", {
      loki_address = "http://${local.loki_svc}/loki/api/v1/push"
    })
  ]

}
