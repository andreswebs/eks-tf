locals {
  flux_namespace = "flux-system"
}

module "flux_secret" {
  source  = "andreswebs/fluxcd-deploy-key-k8s-secret/github"
  version = "1.0.0"

  k8s_namespace       = local.flux_namespace
  git_repository_name = var.flux_repository_name
  git_branch          = var.flux_git_branch
  github_owner        = var.flux_github_owner

  github_deploy_key_readonly = false
}

resource "flux_bootstrap_git" "this" {
  depends_on = [module.flux_secret]
  path       = "clusters/${var.eks_cluster_name}"
}
