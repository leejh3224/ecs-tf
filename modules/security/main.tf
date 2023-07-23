locals {
  alb_sg_name         = "${var.resource_prefix}-alb-sg"
  ecs_service_sg_name = "${var.resource_prefix}-ecs-service-sg"
}

resource "aws_security_group" "ecs_tf_alb" {
  name        = local.alb_sg_name
  description = "sg for ecs-tf alb"
  vpc_id      = var.vpc_main_id

  ingress {
    description = "Allow all inbound traffic on the load balancer listener port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_anywhere]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_anywhere]
  }

  tags = merge(var.common_tags, {
    "name" = local.alb_sg_name,
  })
}

resource "aws_security_group" "ecs_tf_service" {
  name        = local.ecs_service_sg_name
  description = "sg for ecs-tf ecs service"
  vpc_id      = var.vpc_main_id

  ingress {
    description     = "Allow all inbound traffic on the load balancer listener port"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tf_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_anywhere]
  }

  tags = merge(var.common_tags, {
    "name" = local.ecs_service_sg_name,
  })
}
