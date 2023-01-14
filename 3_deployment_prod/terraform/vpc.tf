data "aws_availability_zones" "available" {}

resource "aws_vpc" "cicd_vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "cicd"
  }
}

resource "aws_subnet" "cicd" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.cicd_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.cicd_vpc.cidr_block, 4, count.index)
  
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = false   #private subnet

  tags = {
    Name = format("cicd-%s", data.aws_availability_zones.available.names[count.index])
  }
}

resource "aws_security_group" "cicd" {
  name        = "cicd"
  description = "Allow CICD traffic"
  vpc_id      = aws_vpc.cicd_vpc.id

  ingress {
    description      = "Very permissive"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.cicd_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "cicd"
  }
}
