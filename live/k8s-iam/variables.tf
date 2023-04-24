variable "eks_admin_role_arn" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "external_secrets_names" {
  type = list(string)
  default = []
}
