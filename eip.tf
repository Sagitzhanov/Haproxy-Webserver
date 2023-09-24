# Get Elastic IP for Haproxy
resource "aws_eip" "haproxy" {
  instance = aws_instance.haproxy.id

  tags = {
    Name = "Public IP Haproxy"
  }
}
# Show attached public ip
output "aws_eip" {
  value = aws_eip.haproxy.public_ip
}
