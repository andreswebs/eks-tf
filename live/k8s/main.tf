data "aws_caller_identity" "current" {}

locals {
  has_eks_worker_role = var.eks_worker_role_arn != null && var.eks_worker_role_arn != ""
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# module "ebs_kms_key" {
#   source  = "terraform-aws-modules/kms/aws"
#   version = "~> 1.5"

#   description = "Customer managed key to encrypt EKS managed node group volumes"

#   # Policy
#   key_administrators = [
#     data.aws_caller_identity.current.arn
#   ]

#   key_service_roles_for_autoscaling = [
#     "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
#     module.eks.cluster_iam_role_arn,
#   ]

#   aliases = ["eks/${module.eks.cluster_name}/ebs"]

# }


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.10"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  enable_irsa = true

  cluster_addons = {

    coredns = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }

    kube-proxy = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }

    vpc-cni = {
      most_recent              = true
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }

  }

  vpc_id     = var.vpc_id
  subnet_ids = concat(var.private_subnets, var.public_subnets)

  cluster_enabled_log_types = ["audit"]

  manage_aws_auth_configmap = true

  control_plane_subnet_ids = []

  # cluster_encryption_config = [
  #   {
  #     provider_key_arn = var.eks_encryption_kms_key_arn
  #     resources        = ["secrets"]
  #   }
  # ]

  # manage_worker_iam_resources = false

  # workers_group_defaults = {
  #   iam_instance_profile_name = var.eks_worker_profile_name
  # }

  ## TODO
  ## https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest?tab=inputs
  # cluster_endpoint_private_access_cidrs = # list(string)

  cluster_endpoint_private_access = true

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  eks_managed_node_group_defaults = {
    disk_size                  = 50
    ami_type                   = "AL2_x86_64"
    iam_role_attach_cni_policy = true
  }

  eks_managed_node_groups = {
    workers = {
      name             = "${var.eks_cluster_name}-worker"
      instance_types   = ["t3a.2xlarge"]
      desired_capacity = 2
      min_capacity     = 1
      max_capacity     = 3
      key_name         = var.ssh_key_name
      subnets          = var.private_subnets
      iam_role_arn     = var.eks_worker_role_arn
      create_iam_role  = !local.has_eks_worker_role
    }
  }

  prefix_separator                   = ""
  iam_role_name                      = var.eks_cluster_name
  cluster_security_group_name        = var.eks_cluster_name
  cluster_security_group_description = "EKS cluster security group"

}



module "vpc_cni_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${var.eks_cluster_name}-vpc-cni"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

}
