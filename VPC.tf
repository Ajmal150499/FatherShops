provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "the_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "the-vpc"
  }
}

resource "aws_subnet" "the_subnet" {
  vpc_id     = aws_vpc.the_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  depends_on = [aws_vpc.the_vpc]

  tags = {
    Name = "my-subnet"
  }
}

resource "aws_internet_gateway" "the_igw" {
  vpc_id = aws_vpc.the_vpc.id
  depends_on = [aws_subnet.the_subnet]

  tags = {
    Name = "the-igw"
  }
}

resource "aws_route_table" "the_route_table" {
  vpc_id = aws_vpc.the_vpc.id
  depends_on = [aws_internet_gateway.the_igw]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.the_igw.id
  }

  tags = {
    Name = "the-route-table"
  }
}

resource "aws_route_table_association" "the_subnet_association" {
  subnet_id      = aws_subnet.the_subnet.id
  route_table_id = aws_route_table.the_route_table.id
  depends_on = [aws_route_table.the_route_table]
}
