variable "eks_admin_role_name" {
  type    = string
  default = "eks-admin"
}

variable "eks_admin_role_tag_key" {
  type    = string
  default = "eks-admin"
}

variable "eks_admin_role_tag_value" {
  type    = string
  default = "true"
}

variable "eks_worker_role_name" {
  type    = string
  default = "eks-worker-node"
}

variable "create_eks_admin_role" {
  type    = bool
  default = false
}

variable "create_eks_worker_role" {
  type    = bool
  default = true
}

variable "eks_admin_role_enable_tag_condition" {
  type    = bool
  default = false
}
