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
