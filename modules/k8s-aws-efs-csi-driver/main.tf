/**
* # k8s-aws-efs-csi-driver
*
* Deploys the Amazon EFS CSI driver with proper IAM permissions, and an EFS filesystem
*
*/

terraform {
  required_version = ">= 1.0.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "3.46.0"
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

data "aws_region" "current" {}

locals {
  name        = "aws-efs-csi-driver"
  k8s_sa_name = "efs-csi-controller"
  namespace   = "kube-system"
  chart_versions = {
    aws_efs_csi_driver = "2.1.3"
  }
}

resource "aws_iam_policy" "aws_efs_csi_controller" {
  name        = local.k8s_sa_name
  description = "Permissions for the Amazon EFS CSI Driver controller"
  policy      = file("${path.module}/policies/aws-efs-csi-controller.json")
}

module "assume_role_policy" {
  source                = "andreswebs/eks-irsa-policy-document/aws"
  k8s_sa_name           = local.k8s_sa_name
  k8s_sa_namespace      = local.namespace
  cluster_oidc_provider = var.cluster_oidc_provider
}

resource "aws_iam_role" "aws_efs_csi_controller" {
  name                = local.k8s_sa_name
  assume_role_policy  = module.assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.aws_efs_csi_controller.arn]
}

resource "helm_release" "aws_efs_csi_driver" {
  name       = local.name
  namespace  = local.namespace
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  version    = local.chart_versions["aws_efs_csi_driver"]

  recreate_pods   = true
  reuse_values    = true
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  max_history     = 2


  values = [
    templatefile("${path.module}/helm-values/aws-efs-csi-driver.yml.tpl", {
      k8s_role_arn = aws_iam_role.aws_efs_csi_controller.arn
      k8s_sa_name  = local.k8s_sa_name
    })
  ]

}
