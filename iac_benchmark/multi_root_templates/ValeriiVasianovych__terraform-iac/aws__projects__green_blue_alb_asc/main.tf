terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Owner     = "Valerii Vasianovych"
      CreatedBy = "Terraform"
      Project   = "AWS Green/Blue Deployment with Terraform"
    }
  }
}

data "aws_availability_zones" "available" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default-az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default-az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_security_group" "web" {
  name        = "Web Security Group"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = aws_default_vpc.default.id
  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
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
    Name = "Web Security Group"
  }
}

resource "aws_launch_template" "web" {
  name                   = "WebServer-Highly-Available-LT"
  image_id               = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = filebase64("${path.module}/script.sh")
}

resource "aws_autoscaling_group" "web" {
  name                = "WebServer-Highly-Available-ASG-Ver-${aws_launch_template.web.latest_version}"
  max_size            = 2
  min_size            = 2
  health_check_type   = "ELB"
  vpc_zone_identifier = [aws_default_subnet.default-az1.id, aws_default_subnet.default-az2.id]
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  dynamic "tag" {
    for_each = {
      Name   = "WebServer-In-ASG-v${aws_launch_template.web.latest_version}"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true # This value is used for the lifecycle of the resource
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "web" {
  name               = "WebServer-Highly-Available-LB"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = ["${aws_default_subnet.default-az1.id}", "${aws_default_subnet.default-az2.id}"]
} 

resource "aws_lb_target_group" "web" {
  name                 = "WebServer-Highly-Available-TG"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_default_vpc.default.id
  deregistration_delay = 10
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

output "web_lb_url_name" {
  value = aws_lb.web.dns_name
}
