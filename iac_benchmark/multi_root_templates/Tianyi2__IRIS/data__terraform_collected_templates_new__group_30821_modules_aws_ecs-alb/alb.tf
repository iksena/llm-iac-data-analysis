resource "aws_lb" "lb" {
  name               = var.name
  load_balancer_type = "application"
  internal           = false
  subnets            = var.subnets
  tags = {
    Terraform = "true"
    Name = var.name
  }
  security_groups = [aws_security_group.lb.id]
}


resource "aws_lb_target_group" "lb_target_group" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_port == "443" ? "HTTPS" : "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    path                = var.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    port                = var.health_check_port 
    matcher             = "200,301,302,204"
  }
}


data "aws_acm_certificate" "cert" {
  count = var.domain != "" ? 1 : 0
  domain = var.domain
  statuses = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "zone" {
  count = var.domain != "" ? 1 : 0

  name = var.domain
  private_zone = false
}

resource "aws_lb_listener" "http-only" {
  count = var.domain == "" ? 1 : 0

  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_lb_listener" "http" {
  count = var.domain != "" ? 1 : 0

  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  count = var.domain != "" ? 1 : 0

  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.cert[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_route53_record" "record-lb" {
  count = var.domain != "" ? 1 : 0

  zone_id = data.aws_route53_zone.zone[0].id
  name = var.subdomain != "" ? var.subdomain : var.domain
  type = "A"

  alias {
    name = aws_lb.lb.dns_name
    zone_id = aws_lb.lb.zone_id
    evaluate_target_health = true
  }

  depends_on = [
    aws_lb.lb
  ]
} 