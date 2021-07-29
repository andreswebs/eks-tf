# k8s-monitoring

Deploys the "Grafana + Prometheus + Loki" monitoring stack in a selected namespace in Kubernetes

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.46.0 |
| helm | >= 2.2.0 |
| kubernetes | >= 2.3.2 |
| random | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.46.0 |
| helm | >= 2.2.0 |
| kubernetes | >= 2.3.2 |
| random | >= 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| grafana_assume_role_policy | andreswebs/eks-irsa-policy-document/aws |  |
| loki_assume_role_policy | andreswebs/eks-irsa-policy-document/aws |  |
| loki_compactor_assume_role_policy | andreswebs/eks-irsa-policy-document/aws |  |

## Resources

| Name |
|------|
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [aws_s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) |
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cert\_arn | ARN of TLS certificate from AWS Certificate Manager | `string` | `""` | no |
| cluster\_oidc\_provider | OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster | `string` | `""` | no |
| grafana\_service\_account\_name | Name of the Kubernetes service account for Grafana | `string` | `"grafana"` | no |
| loki\_compactor\_service\_account\_name | Name of the Kubernetes service account for the Loki compactor | `string` | `"loki-compactor"` | no |
| loki\_service\_account\_name | Name of the Kubernetes service account for Loki components | `string` | `"loki-distributed"` | no |
| namespace | Name of a namespace which will be created for deploying the resources | `string` | `"monitoring"` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The name (`metadata.name`) of the namespace |
