resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_anywhere
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    "name" = "public_route_table"
  })
}
