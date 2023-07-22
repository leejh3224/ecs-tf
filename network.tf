resource "aws_vpc" "main" {
  cidr_block = local.cidr_vpc

  tags = merge(local.common_tags, {
    "name" = "main_vpc"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    "name" = "main_igw"
  })
}

resource "aws_subnet" "public_one" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.cidr_public_one

  tags = merge(local.common_tags, {
    "name" = "subnet_public_1",
    "type" = "public"
  })
}

resource "aws_subnet" "public_two" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.cidr_public_two

  tags = merge(local.common_tags, {
    "name" = "subnet_public_2",
    "type" = "public"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = local.cidr_anywhere
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    "name" = "public_route_table"
  })
}

resource "aws_route_table_association" "public_one" {
  subnet_id      = aws_subnet.public_one.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_two" {
  subnet_id      = aws_subnet.public_two.id
  route_table_id = aws_route_table.public.id
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }

  tags = {
    "type" = "public"
  }
}
