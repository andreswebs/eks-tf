variable "create_eks" {
  type    = bool
  default = true
}

variable "write_kubeconfig" {
  type    = bool
  default = false
}

variable "eks_encryption_kms_key_arn" {
  type    = string
  default = ""
}

variable "eks_worker_profile_name" {
  type = string
}

variable "eks_admin_role_arn" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "policy_arn_s3_requisites_for_ssm" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
