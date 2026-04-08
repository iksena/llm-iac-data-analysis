resource "aws_security_group" "sg_rule" {
  name        = "sg_rule"
  description = "Allow HTTP and HTTPS and SSH inbound traffic"

  dynamic "ingress" {
    for_each = var.allow_security_groups_ports

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
}