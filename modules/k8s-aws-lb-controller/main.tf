/**
* # k8s-aws-lb-controller
*
* Deploys the AWS Load Balancer Controller on the kube-system namespace
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

locals {
  name      = "aws-load-balancer-controller"
  namespace = "kube-system"
  labels = {
    "app.kubernetes.io/name" = "aws-load-balancer-controller"
  }
}

resource "aws_iam_policy" "aws_lb_controller" {
  name        = local.name
  description = "Permissions for the AWS Load Balancer Controller"
  policy      = file("${path.module}/policies/aws-load-balancer-controller.json")
}

module "assume_role_policy" {
  source                = "../k8s-assume-role-policy"
  k8s_sa_name           = local.name
  k8s_sa_namespace      = local.namespace
  cluster_oidc_provider = var.cluster_oidc_provider
}

resource "aws_iam_role" "aws_lb_controller" {
  name                = local.name
  assume_role_policy  = module.assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.aws_lb_controller.arn]
}

resource "kubernetes_service_account" "aws_lb_controller" {
  metadata {
    name      = module.assume_role_policy.k8s_sa_name
    namespace = module.assume_role_policy.k8s_sa_namespace
    labels    = local.labels
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_lb_controller.arn
    }
  }
}

resource "helm_release" "aws_lb_controller" {
  name       = local.name
  namespace  = kubernetes_service_account.aws_lb_controller.metadata[0].namespace
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  recreate_pods   = true
  reuse_values    = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_lb_controller.metadata[0].name
  }

}
