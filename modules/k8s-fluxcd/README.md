# k8s-fluxcd

Deploys the FluxCD toolkit on k8s

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| flux | >= 0.0.13 |
| github | 4.5.2 |
| kubectl | >= 1.10.0 |
| kubernetes | >= 2.0.2 |
| tls | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| flux | >= 0.0.13 |
| github | 4.5.2 |
| kubectl | >= 1.10.0 |
| kubernetes | >= 2.0.2 |
| tls | 3.1.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [flux_install](https://registry.terraform.io/providers/fluxcd/flux/latest/docs/data-sources/install) |
| [flux_sync](https://registry.terraform.io/providers/fluxcd/flux/latest/docs/data-sources/sync) |
| [github_repository](https://registry.terraform.io/providers/integrations/github/4.5.2/docs/data-sources/repository) |
| [github_repository_deploy_key](https://registry.terraform.io/providers/integrations/github/4.5.2/docs/resources/repository_deploy_key) |
| [github_repository_file](https://registry.terraform.io/providers/integrations/github/4.5.2/docs/resources/repository_file) |
| [kubectl_file_documents](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/file_documents) |
| [kubectl_manifest](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| git\_branch | Git branch | `string` | `"main"` | no |
| github\_deploy\_key\_title | GitHub deploy key title | `string` | `"flux-key"` | no |
| github\_owner | GitHub owner | `string` | n/a | yes |
| namespace | Name of a namespace which will be created for deploying the resources | `string` | `"flux-system"` | no |
| repository\_name | Name of an existing Git repository to store the FluxCD manifests | `string` | n/a | yes |
| target\_path | Target path for storing FluxCD manifests in the Git repository | `string` | `"flux"` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The name (metadata.name) of the namespace |
