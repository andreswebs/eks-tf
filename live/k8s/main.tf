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


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  create_eks       = var.create_eks
  write_kubeconfig = var.write_kubeconfig

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  enable_irsa     = true
  manage_aws_auth = true

  vpc_id  = var.vpc_id
  subnets = concat(var.private_subnets, var.public_subnets)

  cluster_enabled_log_types = ["audit"]

  # cluster_encryption_config = [
  #   {
  #     provider_key_arn = var.eks_encryption_kms_key_arn
  #     resources        = ["secrets"]
  #   }
  # ]

  # manage_worker_iam_resources = false

  workers_group_defaults = {
    iam_instance_profile_name = var.eks_worker_profile_name
  }

  ## TODO
  ## https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest?tab=inputs
  # cluster_create_endpoint_private_access_sg_rule = # bool
  # cluster_endpoint_private_access_cidrs = # list(string)
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
