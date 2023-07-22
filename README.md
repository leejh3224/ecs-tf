# ECS-TF

Terraform scripts to deploy nginx container on ECS (Fargate) with Application Loadbalancer

## Prerequisites

### AWS

You need an aws account and should have [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed.

Also configuring credentials is required.

Alternatively you can follow [tutorial from Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build).

### Docker

To build and push docker image, you need [Docker Desktop](https://www.docker.com/products/docker-desktop/).

## Caveat

Since it creates new vpc, subnets and various resources, it's highly recommended to run command with fresh aws account or region with zero infrastructure.

## Getting Started

In order to run Terraform scripts, you need to modify `tfvars/example.tfvar` first.

Rename it with `dev.tfvars` and replace dummy values embraced with brackets and run command below.

```
$ terraform plan -var-file="tfvars/dev.tfvars"
```

It would display changed resources.

If it looks OK, run command below to create new resources.

```
$ terraform apply -var-file="tfvars/dev.tfvars"
===
Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

app_url = <app_url>
aws_ecr_repository_url = <aws_ecr_repository_url>
aws_ecr_url = <aws_ecr_url>
aws_profile = <aws_profile>
aws_region = <aws_region>
```

Now we have all of the infrastructure up and running.

Don't forget to save `app_url` output somewhere.

Next, run `scripts/push-image.sh` to build and push a nginx image.

Boom! check ECS task and if it's up and running, visit `app_url` to verify.

## Clean up

```
terraform apply -destroy -var-file="tfvars/dev.tfvars"
```

You'll face an error below, in order to resolve it, manually remove all images from ECR and run the command above again.

```
Error: ECR Repository (<ecr>) not empty, consider using force_delete: RepositoryNotEmptyException: The repository with name '<ecr>' in registry with id '<account_id>' cannot be deleted because it still contains images
```
