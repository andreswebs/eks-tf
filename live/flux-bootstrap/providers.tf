variable "aws_region" {
  type    = string
  default = "us-east-1"
}

locals {
  has_eks_admin_role = var.eks_admin_role_arn != null && var.eks_admin_role_arn != ""
}

provider "aws" {

  region = var.aws_region

  dynamic "assume_role" {
    for_each = local.has_eks_admin_role ? [] : [1]
    content {
      role_arn     = var.eks_admin_role_arn
      session_name = "terraform"
    }
  }

}

data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.this.name]
  }
}

provider "github" {
  owner = var.flux_github_owner
  app_auth {
    id              = var.flux_github_app_id
    installation_id = var.flux_github_app_installation_id
    pem_file        = var.flux_github_app_private_key
  }
}

provider "flux" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }

  git = {
    url    = "ssh://git@github.com/${var.flux_github_owner}/${var.flux_repository_name}.git"
    branch = var.flux_git_branch

    ssh = {
      username    = "git"
      private_key = module.flux_secret.deploy_key.private_key_pem
    }
  }

}
