variable "eks_cluster_name" {
  type = string
}

# https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
variable "eks_cluster_version" {
  type = string
}

variable "eks_worker_role_arn" {
  type    = string
  default = null
}

variable "eks_admin_role_arn" {
  type    = string
  default = null
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "aws_session_name" {
  type    = string
  default = "terraform"
}

variable "whitelisted_cidrs_ipv4" {
  type    = list(string)
  default = []
}
