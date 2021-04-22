/**
 * # k8s-monitoring
 *
 * Deploys a monitoring stack in a namespace in Kubernetes
 *
 */

terraform {
  required_version = ">= 0.14"

  required_providers {

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.2"
    }

  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

locals {
  monitoring_namespace = kubernetes_namespace.monitoring.metadata[0].name
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = local.monitoring_namespace

  recreate_pods   = true
  reuse_values    = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
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

  recreate_pods   = true
  reuse_values    = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2

  values = [
    templatefile("${path.module}/helm-values/grafana.yml.tpl", {
      prom_svc = "prometheus-server.${local.monitoring_namespace}.svc.cluster.local",
      loki_svc = "loki.${local.monitoring_namespace}.svc.cluster.local",
      cert_arn = var.cert_arn
    })
  ]

}

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/loki/charts"
  chart      = "loki"
  namespace  = local.monitoring_namespace

  recreate_pods   = true
  reuse_values    = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2

  values = [
    file("${path.module}/helm-values/loki.yml")
  ]
}

resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = local.monitoring_namespace

  recreate_pods   = true
  reuse_values    = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2

  values = [
    templatefile("${path.module}/helm-values/fluent-bit.yml.tpl", {
      loki_svc = "loki.${local.monitoring_namespace}.svc.cluster.local"
    })
  ]

}
