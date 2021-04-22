provider "aws" {

  region = var.aws_region

  assume_role {
    role_arn     = var.eks_admin_role_arn
    session_name = "terraform"
  }

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
}

module "ec2_role" {
  source       = "../../modules/ec2-role"
  role_name    = "eks-worker-node"
  profile_name = "eks-worker-node"
  policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    var.policy_arn_s3_requisites_for_ssm
  ]
  tags = {
    eks-worker = "true"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"

  create_eks       = var.create_eks
  write_kubeconfig = var.write_kubeconfig

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  enable_irsa     = true
  manage_aws_auth = true

  vpc_id  = var.vpc_id
  subnets = concat(var.private_subnets, var.public_subnets)

  # manage_worker_iam_resources = false

  ## TODO: how to make the workers use the profile created with that module?
  # workers_group_defaults = {
  #   iam_instance_profile_name = module.ec2_role.instance_profile.id
  # }

  ## TODO
  ## https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest?tab=inputs
  # cluster_endpoint_private_access_cidrs = # list(string)
  # cluster_create_endpoint_private_access_sg_rule = # bool
  # cluster_enabled_log_types = # list(string)
  # cluster_encryption_config = # list(object({ provider_key_arn = string resources = list(string) }))
  # cluster_endpoint_private_access = # bool
  # cluster_endpoint_public_access = # bool
  # cluster_endpoint_public_access_cidrs = # list(string) # TODO: get from config whitelist

  node_groups = {
    workers = {
      name             = "workers"
      instance_types   = ["t3a.2xlarge"]
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 3
      key_name         = var.ssh_key_name
      subnets          = var.private_subnets
      iam_role_arn     = module.ec2_role.role.arn
    }
  }

}
