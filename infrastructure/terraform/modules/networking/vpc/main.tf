resource "aws_vpc" "staging-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.staging-vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.availability_zones["az-1"]
  tags = {
    Name = "${var.env_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.staging-vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.availability_zones["az-2"]
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
  destination_cidr_block = var.all_traffic_cidr
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
