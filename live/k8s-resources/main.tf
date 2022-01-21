
data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_id
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

## Note: depends on an imperative deployment of Metrics Server
## kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
## This is being applied with a terragrunt hook in terragrunt.hcl
module "monitoring" {
  source    = "andreswebs/eks-monitoring/aws"
  version   = "0.3.1"
  namespace = var.k8s_monitoring_namespace
  cert_arn  = var.acm_cert_arn
}

## Note: depends on an imperative deployment of CRDs
## kubectl apply -k "https://github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
## This is being applied with a terragrunt hook in terragrunt.hcl
module "aws_lb_controller" {
  source                = "andreswebs/eks-lb-controller/aws"
  version               = "1.1.0"
  cluster_name          = data.aws_eks_cluster.cluster.id
  cluster_oidc_provider = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
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
  cluster_oidc_provider = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
}
