output "ebs_default_key_id" {
  value = aws_kms_key.ebs_default.key_id
}

output "ebs_default_key_arn" {
  value = aws_kms_key.ebs_default.arn
}

output "ebs_default_key_alias_name" {
  value = aws_kms_alias.ebs_default.name
}

output "ebs_default_key_alias_arn" {
  value = aws_kms_alias.ebs_default.arn
}
