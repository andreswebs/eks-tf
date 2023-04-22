module "cert_manager" {
  source                = "andreswebs/eks-irsa/aws"
  version               = "~> 1.0.0"
  k8s_sa_name           = "cert-manager"
  k8s_sa_namespace      = "cert-manager"
  role_name             = "cert-manager-${var.eks_cluster_name}"
  cluster_oidc_provider = local.cluster_oidc_provider
}

module "cert_manager_policy_doc" {
  source  = "andreswebs/eks-cert-manager-iam-policy-document/aws"
  version = "~> 1.0.0"
}

resource "aws_iam_role_policy" "cert_manager" {
  name   = "cert-manager-permissions"
  role   = module.cert_manager.iam_role.id
  policy = module.cert_manager_policy_doc.json
}
