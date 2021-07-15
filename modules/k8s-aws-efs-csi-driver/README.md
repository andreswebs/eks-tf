# k8s-aws-efs-csi-driver

Deploys the Amazon EFS CSI driver with proper IAM permissions, and an EFS filesystem

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | 3.46.0 |
| helm | >= 2.2.0 |
| kubernetes | >= 2.3.2 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.46.0 |
| helm | >= 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| assume_role_policy | ../k8s-assume-role-policy |  |

## Resources

| Name |
|------|
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/resources/iam_policy) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/resources/iam_role) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/data-sources/region) |
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_oidc\_provider | OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster | `string` | n/a | yes |

## Outputs

No output.
