variable "network_name" {
  type = string
}

variable "network_cidr" {
  type    = string
  default = "10.20.8.0/21"
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.20.8.0/24", "10.20.9.0/24", "10.20.10.0/24"]
}

variable "public_subnets" {
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

