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
