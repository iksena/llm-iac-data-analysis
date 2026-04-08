resource "aws_security_group" "bastion" {
  name        = "bastion-security-group"
  description = "Allow 22 traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr
  }


  tags = {
    Name = "bastion-secuirty-group"
  }
}