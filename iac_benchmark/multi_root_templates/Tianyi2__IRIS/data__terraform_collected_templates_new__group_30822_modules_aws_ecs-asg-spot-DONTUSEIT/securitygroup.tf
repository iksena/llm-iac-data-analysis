resource "aws_security_group" "ec2_sg" {
  count = var.create_ec2_spot_sg ? 1 : 0
  name        = var.sg_name
  vpc_id      = var.vpc_id
  description = "EC2 spot security group for ${var.cluster_name}-${var.cluster_environment}"

  dynamic "ingress" {
    for_each = var.tcp_ingress
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }

  dynamic "ingress" {
    for_each = var.allow_additional_sg
    content {
      from_port         = ingress.value.from_port
      to_port           = ingress.value.to_port
      security_groups   = ingress.value.security_groups
      protocol          = ingress.value.protocol
      description       = ingress.key
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
