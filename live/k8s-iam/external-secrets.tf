locals {
  external_secrets_names = [
    "github/p41-arc"
  ]
}

module "external_secrets" {
  source                = "andreswebs/eks-irsa/aws"
  version               = "~> 1.0.0"
  k8s_sa_name           = "external-secrets"
  k8s_sa_namespace      = "external-secrets"
  role_name             = "external-secrets-${var.eks_cluster_name}"
  cluster_oidc_provider = local.cluster_oidc_provider
}

module "external_secrets_policy_doc" {
  source       = "andreswebs/secrets-access-policy-document/aws"
  version      = "~> 1.0.0"
  secret_names = local.external_secrets_names
}

resource "aws_iam_role_policy" "external_secrets" {
  name   = "external-secrets-permissions"
  role   = module.external_secrets.iam_role.id
  policy = module.external_secrets_policy_doc.json
}
