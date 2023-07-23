output "vpc_main_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}
