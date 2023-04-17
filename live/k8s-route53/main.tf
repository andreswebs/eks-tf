data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

locals {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = local.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = local.cluster_ca_certificate
  }
}

data "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = var.k8s_monitoring_namespace
  }
}

locals {
  grafana = regex("^[^-]*", data.kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].hostname)
}

data "aws_lb" "grafana" {
  name = local.grafana
}

resource "aws_route53_record" "grafana" {
  zone_id         = var.route53_zone_id
  name            = "grafana"
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = data.aws_lb.grafana.dns_name
    zone_id                = data.aws_lb.grafana.zone_id
    evaluate_target_health = true
  }
}
