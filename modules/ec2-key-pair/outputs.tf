output "key_pair" {
  value = aws_key_pair.this
  sensitive = true
}

output "ssm_parameter" {
  value = aws_ssm_parameter.key_pair
  sensitive = true
}
