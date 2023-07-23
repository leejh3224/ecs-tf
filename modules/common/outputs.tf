output "common_tags" {
  value = {
    "org"        = var.organization
    "enviroment" = var.environment
    "project"    = var.project
    "owner"      = var.owner
  }
}

output "resource_prefix" {
  value = "${var.environment}-${var.project}"
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "cidr_anywhere" {
  value = "0.0.0.0/0"
}

output "cidr_vpc" {
  value = "10.0.0.0/16"
}

output "cidr_public_one" {
  value = "10.0.1.0/24"
}

output "cidr_public_two" {
  value = "10.0.2.0/24"
}
