# Create ssh key
# Delete temp sg ingress


# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}



# Getting information about a existing VPC
data "aws_vpc" "AWS-VPC" {}



# New subnet will be without public ips
resource "aws_subnet" "private-subnet-main" {
  vpc_id                  = data.aws_vpc.AWS-VPC.id
  map_public_ip_on_launch = "false" //it makes this a public subnet
  availability_zone       = "eu-central-1a"
  cidr_block              = "172.31.48.0/24"
  tags = {
    Name = "private-subnet-main"
  }
}



# Get Elastic IP for Haproxy
resource "aws_eip" "haproxy" {
  instance = aws_instance.haproxy.id
}
# Show attached public ip
output "aws_eip" {
  value = aws_eip.haproxy.public_ip
}




# VM Control with Ansible
resource "aws_instance" "ansible" {
  ami           = "ami-03cbad7144aeda3eb"
  instance_type = "t2.micro"
  key_name      = "s-s_frankfurt"
  user_data     = file("user_data.sh")
  subnet_id     = aws_subnet.private-subnet-main.id
  tags = {
    Name = "Ansible"
  }
  depends_on = [aws_instance.haproxy, aws_instance.webserver]
}
# Show attached private ip
output "ansible-private-ip" {
  value = aws_instance.ansible.private_ip
}


# VMs Webserver
resource "aws_instance" "webserver" {
  count         = 3
  ami           = "ami-03cbad7144aeda3eb"
  instance_type = "t2.micro"
  key_name      = "s-s_frankfurt"
  subnet_id     = aws_subnet.private-subnet-main.id
  tags = {
    Name = "Webserver ${count.index + 1}"
  }
}
# Show attached private ip
output "webserver_private_ips" {
  value = [for instance in aws_instance.webserver : instance.private_ip]
}



# Haproxy
resource "aws_instance" "haproxy" {
  ami                    = "ami-03cbad7144aeda3eb"
  instance_type          = "t2.micro"
  key_name               = "s-s_frankfurt"
  vpc_security_group_ids = [aws_security_group.sg_haproxy.id]
  subnet_id              = aws_subnet.private-subnet-main.id
  tags = {
    Name = "Haproxy"
  }
}
# Show attached private ip
output "haproxy-private-ip" {
  value = aws_instance.haproxy.private_ip
}

# Security Group for Haproxy
resource "aws_security_group" "sg_haproxy" {
  name = "SG_Haproxy"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # temp sg ingress
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG_Haproxy"
  }
}
