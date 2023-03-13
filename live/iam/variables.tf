variable "eks_admin_role_name" {
  type    = string
  default = "eks-admin"
}

variable "create_eks_admin_role" {
  type    = bool
  default = true
}

variable "eks_worker_role_name" {
  type    = string
  default = "eks-worker-node"
}
