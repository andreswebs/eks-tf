module "cert_manager_assume_role_policy" {
  source                = "andreswebs/eks-irsa-policy-document/aws"
  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_sa_name           = var.cert_manager_service_account_name
  k8s_sa_namespace      = local.cert_manager_namespace
}

resource "aws_iam_role" "cert_manager" {
  name                  = "cert-manager"
  assume_role_policy    = module.cert_manager_assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "cert_manager_permissions" {
  name   = "cert-manager-permissions"
  role   = aws_iam_role.cert_manager.id
  policy = file("${path.module}/policies/cert-manager-permissions.json")
}
