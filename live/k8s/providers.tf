variable "aws_region" {
  type = string
  default = "us-east-1"
}

provider "aws" {

  region = var.aws_region

  assume_role {
    role_arn     = var.eks_admin_role_arn
    session_name = "terraform"
  }

}