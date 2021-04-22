include {
  path = find_in_parent_folders()
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

inputs = {
  aws_region = local.config.aws_region
  domain_name = local.config.domain_name
}
