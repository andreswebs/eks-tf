resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_ssm_parameter" "key_pair" {
  name  = var.ssm_parameter_name
  type  = "SecureString"
  value = tls_private_key.this.private_key_pem
}
