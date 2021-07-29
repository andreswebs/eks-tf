# k8s-aws-lb-controller

Deploys the AWS Load Balancer Controller on the kube-system namespace

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
| kubernetes | >= 2.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| assume_role_policy | andreswebs/eks-irsa-policy-document/aws |  |

## Resources

| Name |
|------|
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/resources/iam_policy) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/resources/iam_role) |
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| [kubernetes_service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | Cluster name | `string` | n/a | yes |
| cluster\_oidc\_provider | OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster | `string` | n/a | yes |

## Outputs

No output.
