locals {
  alb_sg_name         = "${local.resource_prefix}-alb-sg"
  ecs_service_sg_name = "${local.resource_prefix}-ecs-service-sg"
}

resource "aws_security_group" "ecs_tf_alb" {
  name        = local.alb_sg_name
  description = "sg for ecs-tf alb"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow all inbound traffic on the load balancer listener port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.cidr_anywhere]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.cidr_anywhere]
  }

  tags = merge(local.common_tags, {
    "name" = local.alb_sg_name,
  })
}

resource "aws_security_group" "ecs_tf_service" {
  name        = local.ecs_service_sg_name
  description = "sg for ecs-tf ecs service"
  vpc_id      = aws_vpc.main.id

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
    cidr_blocks = [local.cidr_anywhere]
  }

  tags = merge(local.common_tags, {
    "name" = local.ecs_service_sg_name,
  })
}