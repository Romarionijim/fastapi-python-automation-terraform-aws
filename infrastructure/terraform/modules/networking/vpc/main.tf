locals {
  cidr_map = { for block in var.cidr_blocks_object : block.name => block.cidr_block }
}

resource "aws_vpc" "staging-vpc" {
  cidr_block = local.cidr_map["vpc_cidr_block"]
  tags = {
    Name = "${var.env_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.staging-vpc.id
  cidr_block        = local.cidr_map["public-subnet-1"]
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "${var.env_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.staging-vpc.id
  cidr_block        = local.cidr_map["public-subnet-2"]
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "${var.env_name}-public-subnet-2"
  }
}

resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.staging-vpc.id
  tags = {
    Name = "${var.env_name}-route-table"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.staging-vpc.id
  tags = {
    Name = "${var.env_name}-igw"
  }
}

resource "aws_route" "route_table_internet_route" {
  route_table_id         = aws_route_table.vpc_route_table.id
  destination_cidr_block = local.cidr_map["all-traffic-cidr-block"]
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "rtb_association_1" {
  route_table_id = aws_route_table.vpc_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "rtb_association_2" {
  route_table_id = aws_route_table.vpc_route_table.id
  subnet_id      = aws_subnet.public_subnet_2.id
}
