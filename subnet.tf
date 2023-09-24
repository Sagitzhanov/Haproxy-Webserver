# Getting information about a existing VPC
data "aws_vpc" "AWS-VPC" {}


resource "aws_internet_gateway" "IGW" {
  vpc_id = data.aws_vpc.AWS-VPC.id
}

# New subnet will be without public ips
resource "aws_subnet" "private-subnet-main" {
  vpc_id                  = data.aws_vpc.AWS-VPC.id
  map_public_ip_on_launch = "false" //it makes this a private subnet
  availability_zone       = "eu-central-1b"
  cidr_block              = "172.31.50.0/24"
  tags = {
    Name = "private-subnet-main"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.AWS-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.private-subnet-main.id
  route_table_id = aws_route_table.private_route_table.id
}

