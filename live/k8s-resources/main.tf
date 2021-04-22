provider "aws" {

  region = var.aws_region

  assume_role {
    role_arn     = var.eks_admin_role_arn
    session_name = "terraform"
  }

}

data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  }
}

## Note: depends on an imperative deployment of Metrics Server
## kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
## This is being applied with a terragrunt hook in terragrunt.hcl
module "k8s_monitoring" {
  source    = "../../modules/k8s-monitoring"
  namespace = var.k8s_monitoring_namespace
  cert_arn  = var.acm_cert_arn
}

## Note: depends on an imperative deployment of CRDs
## kubectl apply -k "https://github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
## This is being applied with a terragrunt hook in terragrunt.hcl
module "aws_lb_controller" {
  source                = "../../modules/k8s-aws-lb-controller"
  cluster_name          = data.aws_eks_cluster.cluster.id
  cluster_oidc_provider = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
}
