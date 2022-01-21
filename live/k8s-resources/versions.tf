terraform {

  required_version = ">= 1.0.0"

  required_providers {

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.2"
    }

    github = {
      source  = "integrations/github"
      version = "4.12.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }

    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.0.13"
    }

  }
}