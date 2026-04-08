resource "aws_lb" "bastion" {
  name                       = var.name
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = var.public_subnets
  enable_deletion_protection = true
}

resource "aws_lb_target_group" "bastion" {
  name                 = var.name
  port                 = var.ssh_port
  protocol             = "TCP"
  vpc_id               = var.vpc_id
  deregistration_delay = "30"
  health_check {
    interval            = "30"
    port                = var.ssh_port
    protocol            = "TCP"
    healthy_threshold   = "10"
    unhealthy_threshold = "10"
  }
}

resource "aws_lb_listener" "bastion" {
  load_balancer_arn = aws_lb.bastion.arn
  port              = var.ssh_port
  protocol          = "TCP"
  default_action {
    target_group_arn = aws_lb_target_group.bastion.arn
    type             = "forward"
  }
}
