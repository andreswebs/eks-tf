# k8s-portworx

Deploys [PX-Backup](https://backup.docs.portworx.com/) from [Portworx](https://docs.portworx.com/).

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.46.0 |
| helm | >= 2.2.0 |
| kubernetes | >= 2.3.2 |

## Providers

| Name | Version |
|------|---------|
| helm | >= 2.2.0 |
| kubernetes | >= 2.3.2 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespace | Name of a namespace which will be created for deploying the resources | `string` | `"px-backup"` | no |
| storage\_class\_name | Name of the Portworx-managed storage class to use for backups | `string` | `"px"` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The name (`metadata.name`) of the namespace |
