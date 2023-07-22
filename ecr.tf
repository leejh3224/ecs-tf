locals {
  repository_name = "${local.resource_prefix}-ecr"
}

resource "aws_ecr_repository" "ecs_tf" {
  name                 = local.repository_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(local.common_tags, {
    "name" = local.repository_name,
  })
}

moved {
  from = aws_ecr_repository.ecs-tf
  to   = aws_ecr_repository.ecs_tf
}
