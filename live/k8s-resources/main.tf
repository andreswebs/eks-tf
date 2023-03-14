locals {
  flux_namespace = "flux-system"
}

module "fluxcd" {
  source          = "andreswebs/fluxcd-bootstrap/github"
  version         = "2.1.0"
  repository_name = var.flux_repository_name
  git_branch      = var.flux_git_branch
  github_owner    = var.flux_github_owner
  flux_namespace  = local.flux_namespace
}

# module "monitoring" {
#   source                = "andreswebs/eks-monitoring/aws"
#   version               = "0.4.0"
#   namespace             = var.k8s_monitoring_namespace
#   cluster_oidc_provider = local.cluster_oidc_provider
# }

# module "aws_lb_controller" {
#   source                = "andreswebs/eks-lb-controller/aws"
#   version               = "1.2.0"
#   cluster_name          = data.aws_eks_cluster.cluster.name
#   cluster_oidc_provider = local.cluster_oidc_provider
# }

# module "chartmuseum" {
#   source                = "andreswebs/eks-chartmuseum/aws"
#   version               = "1.0.0"
#   depends_on            = [module.fluxcd]
#   s3_bucket_name        = var.chartmuseum_s3_bucket_name
#   s3_object_key_prefix  = var.chartmuseum_s3_object_key_prefix
#   k8s_namespace         = local.flux_namespace
#   cluster_oidc_provider = local.cluster_oidc_provider
# }
