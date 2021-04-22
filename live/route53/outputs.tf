output "zone_name" {
  value = data.aws_route53_zone.this.name
}

output "zone_id" {
  value = data.aws_route53_zone.this.zone_id
}

output "name_servers" {
  value = data.aws_route53_zone.this.name_servers
}

output "cert_arn" {
  value = data.aws_acm_certificate.this.arn
}
