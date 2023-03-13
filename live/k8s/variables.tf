variable "write_kubeconfig" {
  type    = bool
  default = false
}

variable "eks_encryption_kms_key_arn" {
  type    = string
  default = null
}

variable "eks_worker_role_arn" {
  type    = string
  default = null
}

variable "eks_admin_role_arn" {
  type    = string
  default = null
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

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(string)
  default = []
}
