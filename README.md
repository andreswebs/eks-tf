# eks-tf

An EKS cluster configured with Terraform and Terragrunt.


## Pre-requisites

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

2. Install [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

3. Install [Helm](https://helm.sh/docs/intro/install/)

This project assumes there is already a Hosted Zone in AWS Route53 for the domain listed in the configuration file (`live/config.yml`, see below), and an AWS ACM certificate for that same domain.


## Configuration

Configuration for all modules is defined in a single file: `live/config.yml`.

Create that file following the example and fill in the values:

```sh
cp live/config.yml.example live/config.yml
```


## IAM Permissions

The IAM user creating the EKS cluster must have the tag `eks-admin=true` to be able to assume the generated administrator IAM role.


## Bootstrapping

```sh
cd ./live
terragrunt run-all apply
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
