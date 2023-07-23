terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9"
    }
  }

  required_version = ">= 1.5.2"

  # Run `terraform apply -var-file=tfvars/dev.tfvars -target=module.backend` to create the S3 bucket
  # And uncomment the following lines:
  # Finally run `terraform init -backend-config=backend.hcl` to initialize the backend
  # backend "s3" {}
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
