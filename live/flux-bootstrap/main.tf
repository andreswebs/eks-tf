locals {
  flux_namespace = "flux-system"
}

module "fluxcd_deploy_key" {
  source  = "andreswebs/fluxcd-deploy-key-k8s-secret/github"
  version = "1.0.0"

  k8s_namespace       = local.flux_namespace
  git_repository_name = var.flux_repository_name
  git_branch          = var.flux_git_branch
  github_owner        = var.flux_github_owner
}
