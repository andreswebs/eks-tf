variable "eks_admin_role_arn" {
  type = string
}

variable "eks_cluster_id" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "route53_zone_name" {
  type = string
}

variable "k8s_monitoring_namespace" {
  type = string
  default = "monitoring"
}
