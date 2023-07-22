locals {
  alb_name              = "${local.resource_prefix}-alb"
  alb_target_group_name = "${local.resource_prefix}-alb-tg"
}

resource "aws_lb" "ecs_tf" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.ecs_tf_alb.id]
  subnets            = data.aws_subnets.public.ids

  tags = merge(local.common_tags, {
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
}

resource "aws_lb_target_group" "ecs_tf" {
  name        = local.alb_target_group_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = merge(local.common_tags, {
    "name" = local.alb_target_group_name,
  })
}
