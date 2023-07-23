locals {
  ecs_cluster_name        = "${var.resource_prefix}-ecs-cluster"
  ecs_service_name        = "${var.resource_prefix}-ecs-service"
  task_def_family_name    = "${var.resource_prefix}-task-def"
  task_def_log_group_name = "${var.resource_prefix}-logs"
}

resource "aws_ecs_cluster" "ecs_tf" {
  name = local.ecs_cluster_name

  tags = merge(var.common_tags, {
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
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = 80
  }
  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.sg_ecs_service_id]
    assign_public_ip = true
  }

  tags = merge(var.common_tags, {
    "name" = local.ecs_service_name,
  })
}

resource "aws_ecs_task_definition" "ecs_tf" {
  family                   = local.task_def_family_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_task_execution_role_arn
  container_definitions = jsonencode([
    {
      "name" : var.container_name,
      "image" : "${var.aws_ecr_repository_url}:latest",
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
