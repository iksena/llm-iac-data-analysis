# target group
resource "aws_lb_target_group" "unity_dapa_tg_tf" {
  name        = "unity-dapa-tg-tf"
  port        = 8080
  protocol    = "TCP"
  target_type = "instance"
  #vpc_id      = data.aws_vpc.default.id
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = 8080
    path                = "/unity/v0/collections/MUR25-JPL-L4-GLOB-v4.2_analysed_sst/processes"
    interval            = 30
    timeout             = 10
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "unity_dapa_tg_tf"
  }
}

# attach instance
resource "aws_lb_target_group_attachment" "unity_dapa_tg_attachment_tf" {
  target_group_arn = aws_lb_target_group.unity_dapa_tg_tf.arn
  target_id        = aws_instance.unity_dapa_instance.id
  port             = 8080
}

# create alb
resource "aws_lb" "unity-dapa-lb-tf" {
  name               = "unity-dapa-lb-tf"
  load_balancer_type = "network"
  internal           = true
  #security_groups    = [var.sg_id]
  #security_groups    = []
  #subnets            = [for subnet in aws_subnet.public : subnet.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  #access_logs {
  #  bucket  = "tbd"
  #  prefix  = "dapa/tbd/unity-dapa-lb"
  #  enabled = true
  #}

  tags = {
    Name = "unity-dapa-lb-tf"
  }
}

resource "aws_lb_listener" "unity_dapa_lb_listener" {
  load_balancer_arn = aws_lb.unity-dapa-lb-tf.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.unity_dapa_tg_tf.arn
  }

  tags = {
    Name = "unity_dapa_lb_listener"
  }
}
