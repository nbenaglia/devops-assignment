data "aws_availability_zones" "available" {}

resource "aws_vpc" "cicd_vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.cicd_vpc.id
  cidr_block = cidrsubnet(aws_vpc.cicd_vpc.cidr_block, 4, 3)

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = false #private subnet

  tags = {
    Name = format("${var.environment}-%s", data.aws_availability_zones.available.names[0])
  }
}

resource "aws_security_group" "cicd" {
  name        = "cicd"
  description = "Allow CICD traffic"
  vpc_id      = aws_vpc.cicd_vpc.id

  ingress {
    description = "Very permissive"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.cicd_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.environment}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.cicd_vpc.id
  tags = {
    Name        = "${var.environment}-ig"
    Environment = "${var.environment}"
  }
}

resource "aws_nat_gateway" "nat" {
  connectivity_type = "public"
  subnet_id         = aws_subnet.private_subnet.id
  depends_on        = [aws_internet_gateway.ig]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.cicd_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}
