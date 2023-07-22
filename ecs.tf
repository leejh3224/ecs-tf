locals {
  ecs_cluster_name        = "${local.resource_prefix}-ecs-cluster"
  ecs_service_name        = "${local.resource_prefix}-ecs-service"
  task_def_family_name    = "${local.resource_prefix}-task-def"
  task_def_log_group_name = "${local.resource_prefix}-logs"
}

resource "aws_ecs_cluster" "ecs_tf" {
  name = local.ecs_cluster_name

  tags = merge(local.common_tags, {
    "name" = local.ecs_cluster_name,
  })

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "ecs_tf" {
  name            = local.ecs_service_name
  cluster         = aws_ecs_cluster.ecs_tf.id
  task_definition = aws_ecs_task_definition.ecs_tf.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tf.arn
    container_name   = var.project
    container_port   = 80
  }
  network_configuration {
    subnets          = data.aws_subnets.public.ids
    security_groups  = [aws_security_group.ecs_tf_service.id]
    assign_public_ip = true
  }

  tags = merge(local.common_tags, {
    "name" = local.ecs_service_name,
  })
}

resource "aws_ecs_task_definition" "ecs_tf" {
  family                   = local.task_def_family_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      "name" : var.project,
      "image" : "${local.aws_ecr_repository_url}:latest",
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : local.task_def_log_group_name,
          "awslogs-region" : "${var.aws_region}",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
}

moved {
  from = aws_ecs_cluster.cluster
  to   = aws_ecs_cluster.ecs_tf
}
