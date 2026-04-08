resource "aws_security_group" "lifecycle_security_group" {
  name        = "terraform_server"
  description = "An example security group for Terraform"

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