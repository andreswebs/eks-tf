output "key_name" {
  value = module.ec2_key_pair.key_pair.key_name
}

output "ssm_parameter" {
  value = module.ec2_key_pair.ssm_parameter.name
}
