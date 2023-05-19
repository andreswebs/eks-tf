terraform {

  required_version = "~> 1.3"

  required_providers {

    aws = {
      source = "hashicorp/aws"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    github = {
      source = "integrations/github"
    }

    tls = {
      source = "hashicorp/tls"
    }

    flux = {
      source  = "fluxcd/flux"
      version = "1.0.0-rc.3"
    }

  }
}
