provider "aws" {
  region = var.aws_region
}

module "ec2_key_pair" {
  source             = "../../modules/ec2-key-pair"
  key_name           = var.ssh_key_name
  ssm_parameter_name = "/eks-tf/ec2-key-pair"
}
