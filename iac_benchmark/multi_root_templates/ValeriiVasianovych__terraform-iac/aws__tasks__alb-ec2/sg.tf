resource "aws_security_group" "web_sg" {
  name = "sg"
  description = "An example security group for Terraform"

  dynamic "ingress" {
    for_each = [22, 80, 443, 8080]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    }

    ingress {
        description     = "HTTP from ALB"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg-group-alb-${var.env}"
    }
}