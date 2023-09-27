# Create VPC and provide a CIDR block range
resource "aws_vpc" "AWS-own-VPC" {
  cidr_block           = "10.0.0.0/20"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "AWS-own-VPC"
  }
}


# Create a Public Subnet for Haproxy with Floating IP
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.AWS-own-VPC.id
  availability_zone       = "eu-central-1b"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}


# Create a Private subnet for Webservers and VM Conroller
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.AWS-own-VPC.id
  availability_zone       = "eu-central-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "private-subnet"
  }
}


# Create an Internet Gateway and attach it to our VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.AWS-own-VPC.id

  tags = {
    Name = "IGW"
  }
}


# Create a Route Table in order to connect our public subnet to the Internet Gateway
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


# Associate this Route Table to the public subnet
resource "aws_route_table_association" "associate-public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.AWS-route-table-public.id
}


# Create Elastic IP
resource "aws_eip" "EIP-NAT-GW" {
  # vpc = true
  domain = "vpc"
  tags = {
    Name = "EIP-NAT-GW"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "NAT-GW" {
  allocation_id = aws_eip.EIP-NAT-GW.id
  subnet_id     = aws_subnet.public-subnet.id


  tags = {
    Name = "NAT-GW"
  }
}


# Create a Route Table in order to connect our private subnet to the NAT Gateway
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


# Associate this route table to private subnet
resource "aws_route_table_association" "associate-private" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.AWS-route-table-private.id
}
