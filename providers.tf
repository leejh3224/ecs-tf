terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9"
    }
  }

  required_version = ">= 1.5.2"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
