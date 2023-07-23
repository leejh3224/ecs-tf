output "sg_ecs_service_id" {
  value = aws_security_group.ecs_tf_service.id
}

output "sg_alb_id" {
  value = aws_security_group.ecs_tf_alb.id
}
