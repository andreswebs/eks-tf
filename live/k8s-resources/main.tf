data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_id
}

locals {
  cluster_oidc_provider = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  }
}

provider "flux" {}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  load_config_file       = false
}

provider "github" {
  owner = var.flux_github_owner
  token = var.flux_github_token
}

locals {
  flux_namespace = "flux-system"
}

module "monitoring" {
  source                = "andreswebs/eks-monitoring/aws"
  version               = "0.4.0"
  namespace             = var.k8s_monitoring_namespace
  cluster_oidc_provider = local.cluster_oidc_provider
}

module "aws_lb_controller" {
  source                = "andreswebs/eks-lb-controller/aws"
  version               = "1.2.0"
  cluster_name          = data.aws_eks_cluster.cluster.id
  cluster_oidc_provider = local.cluster_oidc_provider
}

module "fluxcd" {
  source          = "andreswebs/fluxcd-bootstrap/github"
  version         = "1.0.0"
  repository_name = var.flux_repository_name
  git_branch      = var.flux_git_branch
  github_owner    = var.flux_github_owner
  flux_namespace  = local.flux_namespace
}

module "chartmuseum" {
  source                = "andreswebs/eks-chartmuseum/aws"
  version               = "1.0.0"
  depends_on            = [module.fluxcd]
  s3_bucket_name        = var.chartmuseum_s3_bucket_name
  s3_object_key_prefix  = var.chartmuseum_s3_object_key_prefix
  k8s_namespace         = local.flux_namespace
  cluster_oidc_provider = local.cluster_oidc_provider
}
