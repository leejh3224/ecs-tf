output "alb_target_group_arn" {
  value = aws_lb_target_group.ecs_tf.arn
}

output "alb_dns_name" {
  value = aws_lb.ecs_tf.dns_name
}
  