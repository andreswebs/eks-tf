locals {
  flux_namespace = "flux-system"
}

module "fluxcd" {
  source              = "andreswebs/fluxcd-bootstrap/github"
  version             = "2.1.0"
  git_repository_name = var.flux_repository_name
  git_branch          = var.flux_git_branch
  github_owner        = var.flux_github_owner
  k8s_namespace       = local.flux_namespace
}