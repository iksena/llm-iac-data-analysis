# ── variables.tf ────────────────────────────────────
# Infrastructure Configuration
variable "region" {
  description = "The AWS region"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = ""
}

# Network Configuration
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}

variable "db_private_subnet_ids" {
  description = "List of database private subnet IDs"
  type        = list(string)
  default     = []
}

variable "hosted_zone_name" {
  description = "The name of the hosted zone"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "The id of the hosted zone"
  type        = string
  default     = ""
}

# Instance Configuration
variable "ami" {
  description = "Amazon Machine Image ID for EC2 instances"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Name of the SSH key pair for EC2 instances"
  type        = string
  default     = ""
}

variable "instance_type_public_instance" {
  description = "EC2 instance type for public instances"
  type        = string
  default     = ""
}

variable "instance_type_private_instance" {
  description = "EC2 instance type for private instances"
  type        = string
  default     = ""
}

variable "instance_type_db_instance" {
  description = "EC2 instance type for database instances"
  type        = string
  default     = ""
}

# Security Configuration
variable "public_sg" {
  description = "The ports for the public security group : SSH, HTTP, HTTPS, OpenVPN, OpenVPN Access Server"
  type        = list(number)
  default     = []
}

variable "private_sg" {
  description = "The ports for the private security group: SSH, HTTP, HTTPS, FlaskApp"
  type        = list(string)
  default     = []
}

variable "db_private_sg" {
  description = "The ports for the database security group: mySQL"
  type        = list(string)
  default     = []
}

# VPN Configuration
variable "client_vpn_cidr_block" {
  description = "The id of the hosted zone"
  type        = string
  default     = ""
}

variable "vpn_server_cert_arn" {
  description = "The name of the server certificate"
  type        = string
  default     = ""
}

variable "vpn_client_cert_arn" {
  description = "The name of the client certificate"
  type        = string
  default     = ""
}

locals {
  create_public_resources  = length(var.public_subnet_ids) > 0
  create_private_resources = length(var.private_subnet_ids) > 0
  create_db_resources      = length(var.db_private_subnet_ids) > 0

  use_nlb       = local.create_private_resources && length(var.private_subnet_ids) == 1
  use_alb       = local.create_private_resources && length(var.private_subnet_ids) >= 2
}


# ── outputs.tf ────────────────────────────────────
output "bastion_instance_id" {
  value       = local.create_public_resources ? data.aws_instances.bastion_instances[0].ids : []
  description = "List of IDs of the bastion instances managed by the ASG."
}

output "bastion_instance_ip" {
  value       = local.create_public_resources ? data.aws_instances.bastion_instances[0].public_ips : []
  description = "List of public IPs of the bastion instances managed by the ASG."
}

output "bastion_host_azs" {
  value       = local.create_public_resources ? [data.aws_subnet.public_subnets[0].availability_zone] : []
  description = "List of Availability Zones of the bastion instances."
}

output "private_instance_id" {
  value       = local.create_private_resources ? data.aws_instances.private_instances[0].ids : []
  description = "List of IDs of the private instances managed by the ASG."
}

output "private_instance_ip" {
  value       = local.create_private_resources ? data.aws_instances.private_instances[0].private_ips : []
  description = "List of private IPs of the private instances managed by the ASG."
}

output "private_instances_azs" {
  value       = local.create_private_resources ? [for subnet in data.aws_subnet.private_subnets : subnet.availability_zone] : []
  description = "List of Availability Zones of the private instances."
}

output "application_domain_name" {
  value       = local.create_private_resources ? aws_route53_record.app_domain_record[0].fqdn : null
  description = "The fully qualified domain name (FQDN) of the application, or null if no private subnets are created."
}

# ── app-route53.tf ────────────────────────────────────
# http
# resource "aws_route53_record" "app_domain_record" {
#   zone_id = var.hosted_zone_id
#   name    = var.hosted_zone_name
#   type    = "A"
  
#   alias {
#     name                   = aws_lb.private_instance_alb[0].dns_name
#     zone_id                = aws_lb.private_instance_alb[0].zone_id
#     evaluate_target_health = true                                    
#   }
  
#   depends_on = [aws_lb.private_instance_alb]
# }

# https
resource "aws_acm_certificate" "app_domain_cert" {
  count             = local.create_private_resources ? 1 : 0
  domain_name       = "app.${var.hosted_zone_name}"
  validation_method = "DNS"
  
  # subject_alternative_names = ["app.${var.hosted_zone_name}"]  # Modified to include wildcard if needed
  
  tags = {
    Name = "${var.env}-app-certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "app_cert_validation" {
  for_each = local.create_private_resources ? {
    for dvo in aws_acm_certificate.app_domain_cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "aws_acm_certificate_validation" "app_cert" {
  count                   = local.create_private_resources ? 1 : 0
  certificate_arn         = aws_acm_certificate.app_domain_cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.app_cert_validation : record.fqdn]
}

resource "aws_route53_record" "app_domain_record" {
  count   = local.create_private_resources ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = "app.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = local.use_nlb ? aws_lb.private_instance_nlb[0].dns_name : (local.use_alb ? aws_lb.private_instance_alb[0].dns_name : "")
    zone_id                = local.use_nlb ? aws_lb.private_instance_nlb[0].zone_id : (local.use_alb ? aws_lb.private_instance_alb[0].zone_id : "")
    evaluate_target_health = true
  }

  depends_on = [aws_lb.private_instance_nlb, aws_lb.private_instance_alb]
}

# ── datasource.tf ────────────────────────────────────
data "aws_instances" "bastion_instances" {
  count = length(var.public_subnet_ids) > 0 ? 1 : 0

  instance_tags = {
    Name = "${var.env}-bastion-host-asg-*"
  }
}

data "aws_instances" "private_instances" {
  count = length(var.private_subnet_ids) > 0 ? 1 : 0

  instance_tags = {
    Name = "${var.env}-private-instance-asg-*"
  }

  depends_on = [aws_autoscaling_group.private_instance_asg]
}

data "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_ids)
  id    = var.public_subnet_ids[count.index]
}

data "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_ids)
  id    = var.private_subnet_ids[count.index]
}

data "aws_subnet" "db_private_subnets" {
  count = length(var.db_private_subnet_ids)
  id    = var.db_private_subnet_ids[count.index]
}

# ── private-instance.tf ────────────────────────────────────
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



# ── rds-instance.tf ────────────────────────────────────


# ── security-groups.tf ────────────────────────────────────
# SG for bastion host 80 443 and 22

resource "aws_security_group" "public_sg" {
  count       = length(var.public_subnet_ids) > 0 ? 1 : 0
  name        = "${var.env}-security-group-public"
  vpc_id      = var.vpc_id
  description = "Allows traffic for instances in public subnets"
  dynamic "ingress" {
    for_each = [for port in var.public_sg : port if port != 1194]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = [for port in var.public_sg : port if port == 1194]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-security-group-public"
  }
}

resource "aws_security_group" "private_sg" {
  count       = length(var.private_subnet_ids) > 0 ? 1 : 0
  name        = "${var.env}-security-group-private"
  vpc_id      = var.vpc_id
  description = "Allows traffic for instances in public subnets"
  dynamic "ingress" {
    for_each = var.private_sg
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-security-group-private"
  }
}

resource "aws_security_group" "db_sg" {
  count       = length(var.db_private_subnet_ids) > 0 ? 1 : 0
  name        = "${var.env}-security-group-db"
  vpc_id      = var.vpc_id
  description = "Allows traffic for instances in public subnets"
  dynamic "ingress" {
    for_each = var.db_private_sg
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-security-group-db"
  }
}


# ── vpn-endpoint.tf ────────────────────────────────────
# Client VPN Resources
resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
  count                  = local.create_private_resources ? 1 : 0
  description            = "${var.env}-client-vpn-endpoint"
  client_cidr_block      = var.client_vpn_cidr_block
  split_tunnel           = true
  server_certificate_arn = var.vpn_server_cert_arn
  security_group_ids     = [aws_security_group.private_sg[0].id]
  vpc_id                 = var.vpc_id
  transport_protocol     = "udp"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.vpn_client_cert_arn
  }

  connection_log_options {
    enabled = false
  }

  tags = {
    Name        = "${var.env}-client-vpn"
    Environment = var.env
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_associations" {
  count                  = local.create_private_resources ? length(var.private_subnet_ids) : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint[0].id
  subnet_id              = var.private_subnet_ids[count.index]
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  count                  = local.create_private_resources ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint[0].id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true

  depends_on = [aws_ec2_client_vpn_network_association.vpn_associations]
}