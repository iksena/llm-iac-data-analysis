resource "aws_elb" "weasel_crm_elb" {
  name            = "weasel-crm-elbs"
  security_groups = [aws_security_group.weasel_crm_sg.id]

  subnets = [
    aws_subnet.weasel_crm_public1.id,
    aws_subnet.weasel_crm_public2.id,
    aws_subnet.weasel_crm_public3.id,
  ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  #Uncommit for using https !!!!
  #   listener {
  #   instance_port      = 80
  #   instance_protocol  = "http"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = var.ssl_cert
  # }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "Weasel CRM ELB"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.weasel_crm_asg.id
  elb                    = aws_elb.weasel_crm_elb.id
}