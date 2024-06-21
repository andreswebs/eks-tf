data "aws_caller_identity" "current" {}

locals {
  has_eks_worker_role = var.eks_worker_role_arn != null && var.eks_worker_role_arn != ""
}

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#   }
# }

resource "aws_security_group" "eks_cluster_extra" {
  vpc_id = var.vpc_id
  name   = "${var.eks_cluster_name}-control-plane-extra"

  revoke_rules_on_delete = true

  tags = {
    Name = "${var.eks_cluster_name}-control-plane-extra"
  }
}

resource "aws_vpc_security_group_ingress_rule" "eks_control_plane_whitelisted_ipv4" {
  for_each          = toset(var.whitelisted_cidrs_ipv4)
  security_group_id = aws_security_group.eks_cluster_extra.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443

  cidr_ipv4 = each.value
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.11" ## (last init: 2024-05-23)

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  enable_irsa = true

  enable_cluster_creator_admin_permissions = true

  cluster_addons = {

    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }

    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }

    vpc-cni = {
      most_recent                 = true
      before_compute              = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      service_account_role_arn    = module.vpc_cni_irsa.iam_role_arn

      ## TODO:
      # configuration_values = jsonencode({
      #   env = {
      #     ## https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
      #     ENABLE_PREFIX_DELEGATION = "true"
      #     WARM_PREFIX_TARGET       = "1"
      #   }
      # })
    }

    eks-pod-identity-agent = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }

  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # control_plane_subnet_ids = [] ## TODO

  cluster_additional_security_group_ids = [
    aws_security_group.eks_cluster_extra.id,
  ]

  cluster_endpoint_private_access = true

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  eks_managed_node_group_defaults = {
    disk_size                  = 100
    ami_type                   = "BOTTLEROCKET_x86_64"
    create_launch_template     = false
    use_custom_launch_template = false
    iam_role_arn               = var.eks_worker_role_arn
    create_iam_role            = !local.has_eks_worker_role
  }

  eks_managed_node_groups = {
    workers_default = {
      name             = "${var.eks_cluster_name}-worker"
      use_name_prefix  = false
      instance_types   = ["m6a.2xlarge"]
      desired_capacity = 2
      min_capacity     = 1
      max_capacity     = 3
      subnets          = var.private_subnets
    }
  }

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
