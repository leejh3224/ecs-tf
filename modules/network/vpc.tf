resource "aws_vpc" "main" {
  cidr_block = var.cidr_vpc

  tags = merge(var.common_tags, {
    "name" = "main_vpc"
  })
}
