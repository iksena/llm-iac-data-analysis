# ── variables.tf ────────────────────────────────────

variable "region" {
  default = "us-east-1"
}

# Consul variables

variable "consul_address" {
  type = string
  description = "Address of Consul server"
  default = "127.0.0.1"
}

variable "consul_port" {
  type = number
  description = "Port Consul server is listening on"
  default = "8500"
}

variable "consul_datacenter" {
  type = string
  description = "Name of the Consul datacenter"
  default = "dc1"
}


# Application variables

variable "ip_range" {
  default = "0.0.0.0/0"
}

variable "rds_username" {
  default     = "ddtuser"
  description = "User name"
}

variable "rds_password" {
  default     = "TerraformIsNumber1!"
  description = "password, provide through your ENV variables"
}


# ── backend.tf ────────────────────────────────────
##################################################################################
# BACKENDS
##################################################################################
terraform {
  backend "consul" {
    address = "127.0.0.1:8500"
    scheme = "http"
  }
}


# ── datasources.tf ────────────────────────────────────
##################################################################################
# DATA SOURCES
##################################################################################

data "consul_keys" "applications" {
  key {
      name = "applications"
      path = terraform.workspace == "default" ? "applications/configuration/globo-primary/app_info" : "applications/configuration/globo-primary/${terraform.workspace}/app_info"
  }
  
  key {
    name = "common_tags"
    path = "applications/configuration/globo-primary/common_tags"
  }
}

data "terraform_remote_state" "networking" {
  backend = "consul"

  config = {
    address = "127.0.0.1:8500"
    scheme = "http"
    path     = terraform.workspace == "default" ? "networking/state/globo-primary" : "networking/state/globo-primary-env:${terraform.workspace}"
  }
}

data "aws_ami" "aws_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-20*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


# ── resources.tf ────────────────────────────────────
#Based on the work from https://github.com/arbabnazar/terraform-ansible-aws-vpc-ha-wordpress

##################################################################################
# CONFIGURATION - added for Terraform 0.14
##################################################################################

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>3.0"
    }
    consul = {
      source = "hashicorp/consul"
      version = "~>2.0"
    }
  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  profile = "deep-dive"
  region  = var.region
}

provider "consul" {
  address    = "${var.consul_address}:${var.consul_port}"
  datacenter = var.consul_datacenter
}

##################################################################################
# LOCALS
##################################################################################

locals {
  asg_instance_size = jsondecode(data.consul_keys.applications.var.applications)["asg_instance_size"]
  asg_max_size = jsondecode(data.consul_keys.applications.var.applications)["asg_max_size"]
  asg_min_size = jsondecode(data.consul_keys.applications.var.applications)["asg_min_size"]
  rds_storage_size = jsondecode(data.consul_keys.applications.var.applications)["rds_storage_size"]
  rds_engine = jsondecode(data.consul_keys.applications.var.applications)["rds_engine"]
  rds_version = jsondecode(data.consul_keys.applications.var.applications)["rds_version"]
  rds_instance_size = jsondecode(data.consul_keys.applications.var.applications)["rds_instance_size"]
  rds_multi_az = jsondecode(data.consul_keys.applications.var.applications)["rds_multi_az"]
  rds_db_name = jsondecode(data.consul_keys.applications.var.applications)["rds_db_name"]

  common_tags = merge(jsondecode(data.consul_keys.applications.var.common_tags),
    {
      Environment = terraform.workspace
    }
  )
}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_launch_configuration" "webapp_lc" {
  lifecycle {
    create_before_destroy = true
  }

  name_prefix   = "${terraform.workspace}-ddt-lc-"
  image_id      = data.aws_ami.aws_linux.id
  instance_type = local.asg_instance_size

  security_groups = [
    aws_security_group.webapp_http_inbound_sg.id,
    aws_security_group.webapp_ssh_inbound_sg.id,
    aws_security_group.webapp_outbound_sg.id,
  ]

  user_data                   = file("./templates/userdata.sh")
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.asg.name
}

resource "aws_elb" "webapp_elb" {
  name    = "ddt-webapp-elb-${terraform.workspace}"
  subnets = data.terraform_remote_state.networking.outputs.public_subnets

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  security_groups = [aws_security_group.webapp_http_inbound_sg.id]

  tags = local.common_tags
}

resource "aws_autoscaling_group" "webapp_asg" {
  lifecycle {
    create_before_destroy = true
    #create_before_destroy = false
  }

  vpc_zone_identifier   = data.terraform_remote_state.networking.outputs.public_subnets
  name                  = "ddt_webapp_asg-${terraform.workspace}"
  max_size              = local.asg_max_size
  min_size              = local.asg_min_size
  wait_for_elb_capacity = local.asg_min_size
  force_delete          = true
  launch_configuration  = aws_launch_configuration.webapp_lc.id
  load_balancers        = [aws_elb.webapp_elb.name]

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }
}

#
# Scale Up Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "ddt_asg_scale_up-${terraform.workspace}"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name                = "ddt-high-asg-cpu-${terraform.workspace}"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_description = "EC2 CPU Utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

#
# Scale Down Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "ddt_asg_scale_down-${terraform.workspace}"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 600
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name                = "ddt-low-asg-cpu-${terraform.workspace}"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "5"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "30"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_description = "EC2 CPU Utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}

## Database Config 

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${terraform.workspace}-ddt-rds-subnet-group"
  subnet_ids = data.terraform_remote_state.networking.outputs.private_subnets
}

resource "aws_db_instance" "rds" {
  identifier             = "${terraform.workspace}-ddt-rds"
  allocated_storage      = local.rds_storage_size
  engine                 = local.rds_engine
  engine_version         = local.rds_version
  instance_class         = local.rds_instance_size
  multi_az               = local.rds_multi_az
  name                   = "${terraform.workspace}${local.rds_db_name}"
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  tags = local.common_tags
}


# ── s3.tf ────────────────────────────────────
#### S3 buckets
variable "aws_bucket_prefix" {
  type    = strings
  #type = string
  
  default = "globo"
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals {
  bucket_name         = "${var.aws_bucket_prefix}_${random_integer.rand.result}"
  #bucket_name         = "${var.aws_bucket_prefix}-${random_integer.rand.result}"
}

resource "aws_s3_bucket" "logs_bucket" {
  bucket        = local.bucket_name
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

}

#### Instance profiles

resource "aws_iam_instance_profile" "asg" {

  lifecycle {
    create_before_destroy = false
  }

  name = "${terraform.workspace}_asg_profile_bug"
  role = "aws_iam_role.asg.name"
  #role = aws_iam_role.asg.name
}

#### Instance roles

resource "aws_iam_role" "asg" {
  name = "${terraform.workspace}_asg_role"
  path = "/"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

#### S3 policies

resource "aws_iam_role_policy" "asg" {
  name = "${terraform.workspace}-globo-primary-rds"
  role = aws_iam_role.asg.ids
  #role = aws_iam_role.asg.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource": [
                "arn:aws:s3:::${local.bucket_name}",
                "arn:aws:s3:::${local.bucket_name}/*"
            ]
      }
    ]
  }
  EOF
}


# ── security_groups.tf ────────────────────────────────────
##################################################################################
# RESOURCES
##################################################################################

resource "aws_security_group" "webapp_http_inbound_sg" {
  name        = "demo_webapp_http_inbound"
  description = "Allow HTTP from Anywhere"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id

  tags = {
    Name = "terraform_demo_webapp_http_inbound"
  }
}

resource "aws_security_group" "webapp_ssh_inbound_sg" {
  name        = "demo_webapp_ssh_inbound"
  description = "Allow SSH from certain ranges"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ip_range]
  }

  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id

  tags = merge(local.common_tags,{
    Name = "terraform_demo_webapp_ssh_inbound"
  })
}

resource "aws_security_group" "webapp_outbound_sg" {
  name        = "demo_webapp_outbound"
  description = "Allow outbound connections"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id

  tags = merge(local.common_tags,{
    Name = "terraform_demo_webapp_outbound"
  })
}

resource "aws_security_group" "rds_sg" {
  name        = "demo_rds_inbound"
  description = "Allow inbound from web tier"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  tags = {
    Name = "demo_rds_inbound"
  }

  // allows traffic from the SG itself
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  // allow traffic for TCP 3306
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webapp_http_inbound_sg.id]
  }

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
