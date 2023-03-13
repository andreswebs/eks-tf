variable "ssh_key_name" {
  type    = string
  default = "eks-ssh"
}

variable "ssm_parameter_name" {
  type    = string
  default = "/eks-tf/ec2-key-pair"
}
