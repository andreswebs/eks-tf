/**
* # k8s-aws-efs
*
* Deploys the Amazon EFS CSI driver with proper IAM permissions, and an EFS filesystem
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

data "aws_region" "current" {}

locals {
  name        = "aws-efs-csi-driver"
  k8s_sa_name = "efs-csi-controller"
  namespace   = "kube-system"
}

resource "aws_iam_policy" "aws_efs_csi_controller" {
  name        = local.k8s_sa_name
  description = "Permissions for the Amazon EFS CSI Driver controller"
  policy      = file("${path.module}/policies/aws-efs-csi-controller.json")
}

module "assume_role_policy" {
  source                = "../k8s-assume-role-policy"
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
      k8s_sa_name = local.k8s_sa_name
    })
  ]

}
