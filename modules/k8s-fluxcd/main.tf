/**
 * # k8s-fluxcd
 *
 * Deploys the FluxCD toolkit on k8s
 *
 */

terraform {

  required_version = ">= 0.14"

  required_providers {

    github = {
      source = "integrations/github"
      version = "4.5.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
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

data "github_repository" "this" {
  name = var.repository_name
}

data "flux_install" "this" {
  target_path    = var.target_path
  network_policy = false
}

data "flux_sync" "this" {
  target_path = var.target_path
  url         = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
  branch      = var.git_branch
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = var.namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

# Split multi-doc YAML with
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest
data "kubectl_file_documents" "apply" {
  content = data.flux_install.this.content
}

locals {
  apply = [ for v in data.kubectl_file_documents.apply.documents : {
      data: yamldecode(v)
      content: v
    }
  ]
}

# Apply manifests on the cluster
resource "kubectl_manifest" "apply" {
  for_each   = { for v in local.apply : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body = each.value
}

resource "github_repository_deploy_key" "this" {
  title      = var.github_deploy_key_title
  repository = data.github_repository.this.name
  key        = tls_private_key.this.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  repository = data.github_repository.this.name
  file       = data.flux_install.this.path
  content    = data.flux_install.this.content
  branch     = var.git_branch
}

resource "github_repository_file" "sync" {
  repository = data.github_repository.this.name
  file       = data.flux_sync.this.path
  content    = data.flux_sync.this.content
  branch     = var.git_branch
}

resource "github_repository_file" "kustomize" {
  repository = data.github_repository.this.name
  file       = data.flux_sync.this.kustomize_path
  content    = data.flux_sync.this.kustomize_content
  branch     = var.git_branch
}
