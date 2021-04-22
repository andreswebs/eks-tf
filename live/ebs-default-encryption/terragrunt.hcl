include {
  path = find_in_parent_folders()
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

inputs = {
  aws_region  = local.config.aws_region
  kms_key_name = local.config.kms_key_name
}
