# Creation of NLB for private instances
resource "aws_lb" "private_instance_nlb" {
  count              = local.use_nlb ? 1 : 0
  name               = "${var.env}-private-instance-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids

  tags = {
    Name = "${var.env}-private-instance-nlb"
  }
}

resource "aws_lb_target_group" "private_instance_tg_nlb" {
  count       = local.use_nlb ? 1 : 0
  name        = "${var.env}-private-tg-nlb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol            = "TCP"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.env}-private-tg-nlb"
  }
}

resource "aws_lb_listener" "private_instance_listener_nlb_tls" {
  count             = local.use_nlb ? 1 : 0
  load_balancer_arn = aws_lb.private_instance_nlb[0].arn
  port              = 443
  protocol          = "TLS"
  certificate_arn   = local.create_private_resources ? aws_acm_certificate_validation.app_cert[0].certificate_arn : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_instance_tg_nlb[0].arn
  }

  depends_on = [aws_acm_certificate_validation.app_cert]
}

# Creation of ALB for private instances
resource "aws_lb" "private_instance_alb" {
  count              = local.use_alb ? 1 : 0
  name               = "${var.env}-private-instance-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_sg[0].id]
  subnets            = var.private_subnet_ids

  tags = {
    Name = "${var.env}-private-instance-alb"
  }
}

resource "aws_lb_target_group" "private_instance_tg_alb" {
  count       = local.use_alb ? 1 : 0
  name        = "${var.env}-private-tg-alb"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.env}-private-tg-alb"
  }
}

resource "aws_lb_listener" "private_instance_listener_alb_https" {
  count             = local.use_alb ? 1 : 0
  load_balancer_arn = aws_lb.private_instance_alb[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = local.create_private_resources ? aws_acm_certificate_validation.app_cert[0].certificate_arn : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_instance_tg_alb[0].arn
  }

  depends_on = [aws_acm_certificate_validation.app_cert]
}

# resource "aws_lb_listener" "private_instance_listener" {
#   count             = local.create_private_resources ? 1 : 0
#   load_balancer_arn = aws_lb.private_instance_alb[0].arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.private_instance_tg[0].arn
#   }
# }

# Creation of ASG for private instances
resource "aws_launch_template" "private_instance_lt" {
  count         = local.create_private_resources ? 1 : 0
  image_id      = var.ami
  instance_type = var.instance_type_private_instance
  key_name      = var.key_name
  user_data     = filebase64("${path.module}/scripts/install-nginx.sh")
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.private_sg[0].id]
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name = "${var.env}-private-instance-lt"
  }
}

resource "aws_autoscaling_group" "private_instance_asg" {
  count               = local.create_private_resources ? 1 : 0
  vpc_zone_identifier = var.private_subnet_ids
  desired_capacity    = local.use_nlb ? 2 : length(var.private_subnet_ids)
  max_size            = local.use_nlb ? 2 : length(var.private_subnet_ids)
  min_size            = 1

  launch_template {
    id      = aws_launch_template.private_instance_lt[0].id
    version = "$Latest"
  }

  target_group_arns = local.create_private_resources ? (local.use_nlb ? [aws_lb_target_group.private_instance_tg_nlb[0].arn] : [aws_lb_target_group.private_instance_tg_alb[0].arn]) : []

  dynamic "tag" {
    for_each = {
      for idx in range(local.use_nlb ? 2 : length(var.private_subnet_ids)) : idx => {
        key   = "Name"
        value = format("${var.env}-private-instance-%03d", idx + 1)
      }
    }
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = true
    }
  }
}

