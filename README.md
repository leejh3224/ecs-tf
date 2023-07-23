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

It would display new resources.

The problem is nginx image needs to be pushed after creating ECR repository.

Below is a workaround for this.

```
# Create new ECR repository only
$ terraform apply -var-file="tfvars/dev.tfvars" -target="module.ecr"

# Fill out outputs required for `push-image.sh` to run
$ terraform apply -var-file="tfvars/dev.tfvars" -refresh-only

# Build/push docker image
$ scripts/push-image.sh
```

It will only create ECR repository and fill out outputs required for `scripts/push-image.sh` so that we can safely push images to it.

Now that we have ECR repository and docker image set up, it's time to apply other changes too.

```
$ terraform apply -var-file="tfvars/dev.tfvars"
===
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:

app_url = <app_url>
aws_ecr_repository_url = <aws_ecr_repository_url>
aws_ecr_url = <aws_ecr_url>
aws_profile = <aws_profile>
aws_region = <aws_region>
```

Now we have all of the infrastructure up and running.

Don't forget to save `app_url` output somewhere.

Boom! visit `app_url` to see if our server is working correctly.

## Clean up

```
terraform apply -destroy -var-file="tfvars/dev.tfvars"
```
