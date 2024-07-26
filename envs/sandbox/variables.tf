variable "eks_cluster_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(string)
  default = []
}
