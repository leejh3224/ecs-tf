locals {
  repository_name = "${var.resource_prefix}-ecr"
  aws_ecr_url = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}

resource "aws_ecr_repository" "ecs_tf" {
  name                 = local.repository_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  # Caveat: don't use this in production
  # To delete non empty repository for demonstration purposes
  force_delete = true

  tags = merge(var.common_tags, {
    "name" = local.repository_name,
  })
}

moved {
  from = aws_ecr_repository.ecs-tf
  to   = aws_ecr_repository.ecs_tf
}
