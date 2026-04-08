resource "aws_lb" "webservers_nlb" {
  name               = "webservers-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [data.terraform_remote_state.ec2.outputs.sg_group_id]

  enable_deletion_protection = false

  dynamic "subnet_mapping" {
    for_each = data.terraform_remote_state.vpc.outputs.public_subnet_ids
    content {
      subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_ids[subnet_mapping.key]
    }
  }

  tags = merge(module.common_vars.common_tags, {
    Name = "webservers-nlb-${module.common_vars.env}"
    Type = "NLB"
    VPC  = data.terraform_remote_state.vpc.outputs.vpc_id["id"]
  })

  depends_on = [data.terraform_remote_state.vpc]
}

resource "aws_lb_target_group" "webservers_tg" {
  name     = "webservers-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id["id"]

  health_check {
    interval            = 30
    protocol            = "TCP"
    timeout             = 5
    unhealthy_threshold = 3
    healthy_threshold   = 3
  }

  tags = merge(module.common_vars.common_tags, {
    Name        = "webservers-tg-${module.common_vars.env}"
    Environment = module.common_vars.env
  })
}

resource "aws_lb_target_group_attachment" "webservers_tg_attachment" {
  count               = length(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  target_group_arn    = aws_lb_target_group.webservers_tg.arn
  target_id           = data.terraform_remote_state.ec2.outputs.webservers_ids[count.index]
  port                = 80
}

resource "aws_lb_listener" "webservers_listener" {
  load_balancer_arn = aws_lb.webservers_nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webservers_tg.arn
  }
}
