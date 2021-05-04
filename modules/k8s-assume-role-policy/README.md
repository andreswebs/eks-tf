# k8s-assume-role-policy

Creates a trust policy for an IAM role that can be assumed by  
a Kubernetes service account

The cluster OIDC provider value can be found with the  
command:

```sh
aws eks describe-cluster \
  --name "${CLUSTER_NAME}" \
  --query "cluster.identity.oidc.issuer" \
  --output text | sed -e "s/^https:\\/\\///"
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_oidc\_provider | OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster | `string` | n/a | yes |
| k8s\_sa\_name | Name of the Kubernetes service account | `string` | `"default"` | no |
| k8s\_sa\_namespace | Namespace of the Kubernetes service account | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| json | The IAM policy JSON contents |
| k8s\_sa\_name | Name of the Kubernetes service account |
| k8s\_sa\_namespace | Namespace of the Kubernetes service account |
