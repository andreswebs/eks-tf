output "key_pair" {
  value = aws_key_pair.this
}

output "ssm_parameter" {
  value = aws_ssm_parameter.key_pair
}
