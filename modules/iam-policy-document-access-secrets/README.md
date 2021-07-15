# iam-policy-document-access-secrets

Generates an IAM policy document with permissons to access a specifically named secret  
from Secrets Manager.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | 3.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.46.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/data-sources/caller_identity) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/data-sources/iam_policy_document) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/data-sources/partition) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/3.46.0/docs/data-sources/region) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| secret\_names | Friendly names of the secrets to be allowed access to | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| document | The IAM Policy document data object |
