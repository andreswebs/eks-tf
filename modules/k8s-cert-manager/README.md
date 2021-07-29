# k8s-cert-manager

Deploys [cert-manager](https://cert-manager.io).

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
| aws | >= 3.46.0 |
| helm | >= 2.2.0 |
| kubernetes | >= 2.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cert_manager_assume_role_policy | andreswebs/eks-irsa-policy-document/aws |  |

## Resources

| Name |
|------|
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) |
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cert\_manager\_service\_account\_name | Name of the Kubernetes service account for cert-manager | `string` | `"cert-manager"` | no |
| cluster\_oidc\_provider | OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster | `string` | `""` | no |
| namespace | Name of a namespace which will be created for deploying the resources | `string` | `"cert-manager"` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The name (`metadata.name`) of the namespace |
