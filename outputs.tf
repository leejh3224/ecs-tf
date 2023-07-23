output "aws_region" {
  value = var.aws_region
}

output "aws_ecr_url" {
  value = module.ecr.aws_ecr_url
}

output "aws_ecr_repository_url" {
  value = module.ecr.aws_ecr_repository_url
}

output "aws_profile" {
  value = var.aws_profile
}

output "app_url" {
  value = module.loadbalancer.alb_dns_name
}
