include {
  path = find_in_parent_folders()
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
}

inputs = {
  aws_region = local.config.aws_region
  github_token_secret = local.config.github_token_secret
}
