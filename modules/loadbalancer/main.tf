locals {
  alb_name              = "${var.resource_prefix}-alb"
  alb_listener_name     = "${var.resource_prefix}-alb-listener"
  alb_target_group_name = "${var.resource_prefix}-alb-tg"
}

resource "aws_lb" "ecs_tf" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [var.sg_alb_id]
  subnets            = var.public_subnet_ids

  tags = merge(var.common_tags, {
    "name" = local.alb_name,
  })
}

resource "aws_lb_listener" "ecs_tf" {
  load_balancer_arn = aws_lb.ecs_tf.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tf.arn
  }

  tags = merge(var.common_tags, {
    "name" = local.alb_listener_name,
  })
}

resource "aws_lb_target_group" "ecs_tf" {
  name        = local.alb_target_group_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_main_id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = merge(var.common_tags, {
    "name" = local.alb_target_group_name,
  })
}
