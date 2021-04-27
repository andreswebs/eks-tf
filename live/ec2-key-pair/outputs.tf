output "key_name" {
  value = nonsensitive(module.ec2_key_pair.key_pair.key_name)
}

output "ssm_parameter" {
  value = nonsensitive(module.ec2_key_pair.ssm_parameter.name)
}
