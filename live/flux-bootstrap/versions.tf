terraform {

  required_version = "~> 1.3"

  required_providers {

    kubernetes = {
      source  = "hashicorp/kubernetes"
    }

    helm = {
      source  = "hashicorp/helm"
    }

    github = {
      source  = "integrations/github"
    }

    tls = {
      source  = "hashicorp/tls"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
    }

    flux = {
      source  = "fluxcd/flux"
    }

  }
}
