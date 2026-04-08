resource "aws_security_group" "ui" {
  name        = "ui"
  description = "UI Security group. Supports TLS and HTTP."
  vpc_id      = module.vpc_networking.vpc_id

  ingress {
    description      = "TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ui"
  }
}

resource "aws_security_group" "api" {
  name        = "API"
  description = "API security group"
  vpc_id      = module.vpc_networking.vpc_id

  ingress {
    description      = "TLS from UI"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
    security_groups  = [aws_security_group.ui.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

