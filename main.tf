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

# variables
locals {
  # common tags for all resources
  common_tags = {
    "org"        = var.organization
    "enviroment" = var.environment
    "project"    = var.project
    "owner"      = var.owner
  }

  resource_prefix = "${var.environment}-${var.project}"

  # utils
  aws_account_id         = data.aws_caller_identity.current.account_id
  aws_ecr_url            = "${local.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
  aws_ecr_repository_url = "${local.aws_ecr_url}/${local.repository_name}"

  cidr_anywhere   = "0.0.0.0/0"
  cidr_vpc        = "10.0.0.0/16"
  cidr_public_one = "10.0.1.0/24"
  cidr_public_two = "10.0.2.0/24"
}

variable "project" {
  description = "Project name"
  type        = string
  nullable    = false
}

variable "organization" {
  description = "Organization name"
  type        = string
  nullable    = false
}

variable "owner" {
  description = "Owner of the project"
  type        = string
  nullable    = false
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  nullable    = false
}

variable "aws_region" {
  description = "AWS region to use"
  type        = string
  nullable    = false
}

variable "environment" {
  description = "Environment to deploy"
  type        = string
  nullable    = false
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Enviroment must be one of dev, staging, prod"
  }
}

# outputs
output "aws_region" {
  value = var.aws_region
}

output "aws_ecr_url" {
  value = local.aws_ecr_url
}

output "aws_ecr_repository_url" {
  value = local.aws_ecr_repository_url
}

output "aws_profile" {
  value = var.aws_profile
}

output "app_url" {
  value = aws_lb.ecs_tf.dns_name
}
