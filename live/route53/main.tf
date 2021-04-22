provider "aws" {
  region = var.aws_region
}

data "aws_route53_zone" "this" {
  name = var.domain_name
}

data "aws_acm_certificate" "this" {
  domain = var.domain_name
}
