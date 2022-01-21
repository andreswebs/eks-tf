module "ec2_key_pair" {
  source  = "andreswebs/insecure-ec2-key-pair/aws"
  version = "1.0.0"
  key_name           = var.ssh_key_name
  ssm_parameter_name = "/eks-tf/ec2-key-pair"
}
