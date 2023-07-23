output "aws_ecr_url" {
  value = local.aws_ecr_url
}

output "aws_ecr_repository_url" {
  value = "${local.aws_ecr_url}/${local.repository_name}"
}
