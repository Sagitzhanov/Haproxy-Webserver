# Create ssh key
# Delete temp sg ingress


# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}



# Haproxy
resource "aws_instance" "haproxy" {
  ami                    = "ami-03cbad7144aeda3eb"
  instance_type          = "t2.micro"
  key_name               = "s-s_frankfurt"
  subnet_id              = aws_subnet.private-subnet-main.id
  vpc_security_group_ids = [aws_security_group.sg_haproxy.id]
  private_ip             = "172.31.50.100"

  tags = {
    Name = "Haproxy"
  }
}



# VM Control with Ansible
resource "aws_instance" "ansible" {
  ami                    = "ami-03cbad7144aeda3eb"
  instance_type          = "t2.micro"
  key_name               = "s-s_frankfurt"
  subnet_id              = aws_subnet.private-subnet-main.id
  vpc_security_group_ids = [aws_security_group.sg_private_vm.id]
  user_data              = file("user_data.sh")
  private_ip             = "172.31.50.101"

  tags = {
    Name = "Ansible"
  }
  depends_on = [aws_instance.haproxy, aws_instance.webserver1, aws_instance.webserver2, aws_instance.webserver3]
}




# VM Webserver-1
resource "aws_instance" "webserver1" {
  ami                    = "ami-03cbad7144aeda3eb"
  instance_type          = "t2.micro"
  key_name               = "s-s_frankfurt"
  subnet_id              = aws_subnet.private-subnet-main.id
  vpc_security_group_ids = [aws_security_group.sg_private_vm.id]
  private_ip             = "172.31.50.110"

  tags = {
    Name = "Webserver-1"
  }
}


# VM Webserver-2
resource "aws_instance" "webserver2" {
  ami                    = "ami-03cbad7144aeda3eb"
  instance_type          = "t2.micro"
  key_name               = "s-s_frankfurt"
  subnet_id              = aws_subnet.private-subnet-main.id
  vpc_security_group_ids = [aws_security_group.sg_private_vm.id]
  private_ip             = "172.31.50.120"

  tags = {
    Name = "Webserver-2"
  }
}


# VM Webserver-3
resource "aws_instance" "webserver3" {
  ami                    = "ami-03cbad7144aeda3eb"
  instance_type          = "t2.micro"
  key_name               = "s-s_frankfurt"
  subnet_id              = aws_subnet.private-subnet-main.id
  vpc_security_group_ids = [aws_security_group.sg_private_vm.id]
  private_ip             = "172.31.50.130"

  tags = {
    Name = "Webserver-3"
  }
}
