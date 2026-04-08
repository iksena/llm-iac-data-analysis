resource "aws_security_group" "cluster" {
  name        = "${var.cluster_name}-sg"
  vpc_id      = var.vpc_id
  description = "${var.cluster_name} security group"


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

  tags = {
    "Name" = "${var.cluster_name}-sg"
  }
}

resource "aws_security_group_rule" "cluster-allow-lb" {
  count = var.allow_cluster_lb ? 1 : 0
  security_group_id = aws_security_group.cluster.id
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "tcp"
  source_security_group_id = var.loadbalancer_sg
}