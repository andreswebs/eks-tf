variable "eks_cluster_name" {
  type    = string
  default = null
}

variable "network_name" {
  type = string
}

variable "network_cidr_ipv4" {
  type    = string
  default = "10.20.8.0/21"
}

variable "private_subnet_cidrs_ipv4" {
  type    = list(string)
  default = ["10.20.8.0/24", "10.20.9.0/24", "10.20.10.0/24"]
}

variable "public_subnet_cidrs_ipv4" {
  type    = list(string)
  default = ["10.20.11.0/24", "10.20.12.0/24", "10.20.13.0/24"]
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "public_subnet_tags" {
  type    = map(string)
  default = {}
}

