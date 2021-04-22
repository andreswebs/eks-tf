# k8s-monitoring

Deploys a monitoring stack in a namespace in Kubernetes

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| helm | >= 2.0.2 |
| kubernetes | >= 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| helm | >= 2.0.2 |
| kubernetes | >= 2.0.2 |

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
| namespace | Name of a namespace which will be created for deploying the resources | `string` | `"monitoring"` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The name (metadata.name) of the namespace |
