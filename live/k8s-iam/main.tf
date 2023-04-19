module "cert_manager" {
  source                = "andreswebs/eks-irsa/aws"
  version               = "~> 1.0.0"
  k8s_sa_name           = "cert-manager"
  k8s_sa_namespace      = "cert-manager"
  role_name             = "cert-manager-${var.eks_cluster_name}"
  cluster_oidc_provider = local.cluster_oidc_provider
}
