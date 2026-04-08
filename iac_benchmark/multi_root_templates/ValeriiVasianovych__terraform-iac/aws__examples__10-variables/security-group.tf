
resource "aws_security_group" "web_sg" {
  name        = "Web Security Group"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allow_sg_ports # List of ports to open, default is [22, 80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = merge(var.common_tags, {
    Name = "Web Security Group"
  })
}