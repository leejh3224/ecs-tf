data "aws_iam_policy_document" "ecs_tasks_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name                = "ecsTaskExecutionRole"
  assume_role_policy  = data.aws_iam_policy_document.ecs_tasks_trust_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
  inline_policy {
    name = "createLogGroup"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:CreateLogGroup"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}
