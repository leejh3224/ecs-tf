resource "aws_subnet" "public_one" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_public_one
  availability_zone = var.az_subnet_public_one

  tags = merge(var.common_tags, {
    "name" = "subnet_public_1",
    "type" = "public"
  })
}

resource "aws_route_table_association" "public_one" {
  subnet_id      = aws_subnet.public_one.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public_two" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_public_two
  availability_zone = var.az_subnet_public_two

  tags = merge(var.common_tags, {
    "name" = "subnet_public_2",
    "type" = "public"
  })
}

resource "aws_route_table_association" "public_two" {
  subnet_id      = aws_subnet.public_two.id
  route_table_id = aws_route_table.public.id
}
