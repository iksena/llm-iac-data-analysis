# SG for bastion host 80 443 and 22

resource "aws_security_group" "public_sg" {
  count       = length(var.public_subnet_ids) > 0 ? 1 : 0
  name        = "${var.env}-security-group-public"
  vpc_id      = var.vpc_id
  description = "Allows traffic for instances in public subnets"
  dynamic "ingress" {
    for_each = [for port in var.public_sg : port if port != 1194]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = [for port in var.public_sg : port if port == 1194]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-security-group-public"
  }
}

resource "aws_security_group" "private_sg" {
  count       = length(var.private_subnet_ids) > 0 ? 1 : 0
  name        = "${var.env}-security-group-private"
  vpc_id      = var.vpc_id
  description = "Allows traffic for instances in public subnets"
  dynamic "ingress" {
    for_each = var.private_sg
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-security-group-private"
  }
}

resource "aws_security_group" "db_sg" {
  count       = length(var.db_private_subnet_ids) > 0 ? 1 : 0
  name        = "${var.env}-security-group-db"
  vpc_id      = var.vpc_id
  description = "Allows traffic for instances in public subnets"
  dynamic "ingress" {
    for_each = var.db_private_sg
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-security-group-db"
  }
}
