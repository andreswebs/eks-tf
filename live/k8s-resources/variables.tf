variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "eks_admin_role_arn" {
  type = string
}

variable "eks_cluster_id" {
  type = string
}

variable "acm_cert_arn" {
  type = string
}

variable "k8s_monitoring_namespace" {
  type = string
  default = "monitoring"
}
