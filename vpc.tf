resource "aws_vpc" "AWS-own-VPC" {
  cidr_block           = "10.0.0.0/20"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "AWS-own-VPC"
  }
}



resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.AWS-own-VPC.id
  availability_zone       = "eu-central-1b"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}


resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.AWS-own-VPC.id
  availability_zone       = "eu-central-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "private-subnet"
  }
}



resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.AWS-own-VPC.id

  tags = {
    Name = "IGW"
  }
}



resource "aws_route_table" "AWS-route-table-public" {
  vpc_id = aws_vpc.AWS-own-VPC.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "AWS-route-table-public"
  }
}



resource "aws_route_table_association" "associate-public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.AWS-route-table-public.id
}




resource "aws_eip" "EIP-NAT-GW" {
  # vpc = true
  domain = "vpc"
  tags = {
    Name = "EIP-NAT-GW"
  }
}


resource "aws_nat_gateway" "NAT-GW" {
  allocation_id = aws_eip.EIP-NAT-GW.id
  subnet_id     = aws_subnet.public-subnet.id


  tags = {
    Name = "NAT-GW"
  }
}



resource "aws_route_table" "AWS-route-table-private" {
  vpc_id = aws_vpc.AWS-own-VPC.id


  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT-GW.id
  }

  tags = {
    Name = "AWS-route-table-private"
  }
}



resource "aws_route_table_association" "associate-private" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.AWS-route-table-private.id
}
