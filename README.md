# eks-tf

An EKS cluster configured with Terraform and Terragrunt.

## Pre-requisites

1. Install
   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

2. Install
   [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

3. Install [Helm](https://helm.sh/docs/intro/install/)

This project assumes the following resources already exist:

- a Hosted Zone in AWS Route53 for the domain listed in the configuration file
  (`live/config.yml`, see below), and an AWS ACM certificate for that same
  domain;

- a GitHub repository to be used by FluxCD to store k8s configurations;

- a secret in AWS Secrets Manager containing credentials for a GitHub App. The
  GitHub App must have repository admin permissions for the FluxCD repo
  mentioned above. The secret name must be what is defined in the
  `live/config.yml` key `github_app_secret`. The secret's JSON value must
  contain the following properties, whose values must be base64-encoded strings:

```json
{
  "github_app_id_base64": "...",
  "github_app_installation_id_base64": "...",
  "github_app_private_key_base64": "..."
}
```

## Configuration

Configuration for all modules is defined in a single file: `live/config.yml`.

Create that file following the example and fill in the values:

```sh
cp live/config.yml.example live/config.yml
```

## IAM Permissions

The IAM user creating the EKS cluster must have the tag `eks-admin=true` to be
able to assume the generated administrator IAM role.

## Bootstrapping

```sh
cd ./live
terragrunt run-all apply
```

### Order of apply

```yaml
first:
  - iam
  - network
  - route53: [ config.domain_name ]

second:
  - k8s: [ iam, network ]
  - env-secrets: [ config.github_app_secret ]

third:
  - flux-bootstrap: [ k8s, env-secrets ]
```

## Clean up

To delete all the resources, run:

```sh
cd ./live
terragrunt run-all destroy
```

## Authors

**Andre Silva** [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE.md).
