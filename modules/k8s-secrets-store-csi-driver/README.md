# k8s-aws-secrets-store-csi-driver

Deploys the Kubernets CSI Secrets Store Driver and the AWS Secrets Manager and Config Provider for the driver

## References

<https://secrets-store-csi-driver.sigs.k8s.io>

<https://github.com/aws/secrets-store-csi-driver-provider-aws>

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| helm | >= 2.2.0 |
| kubernetes | >= 2.3.2 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| helm | >= 2.2.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable\_secret\_rotation | Set Helm value `enableSecretRotation` | `string` | `"true"` | no |
| enable\_secret\_sync | Set Helm value `syncSecret.enabled` | `string` | `"true"` | no |
| rotation\_poll\_interval | Set Helm value `rotationPollInterval` | `string` | `"3600s"` | no |

## Outputs

No output.
