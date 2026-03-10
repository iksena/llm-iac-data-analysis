# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/tasks/alb-ec2/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
        Environment = var.env
        Owner = "Valerii Vasianovych"
        Project = "ALB Project"
    }
  }
}

resource "aws_eip" "alb_eip" {
  count = 1
  tags = {
    Name = "alb-eip-${count.index + 1}-${var.env}"
  }
  
}

# ── variables.tf ────────────────────────────────────
variable "region" {
    type = string
    description = "The region in which to launch the EC2 instance"
    default = "us-east-1"
}

variable "instance_count" {
    description = "Number of EC2 instances to create"
    type        = number
    default     = 2
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t2.micro"
}

variable "env" {
    description = "Environment name"
    type        = string
    default     = "dev"
}

variable "key_name" {
    type = string
    description = "The name of the key pair to use for the instance"
    default = "aws_ssh_key"
}

variable "count_instance" {
    type = number
    description = "The number of instances to launch"
    default = 1
}

# ── alb.tf ────────────────────────────────────
# Create Application Load Balancer
resource "aws_lb" "web_alb" {
  name               = "web-alb-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets           = data.aws_subnets.subnets.ids

  tags = {
    Environment = var.env
    Name        = "web-alb-${var.env}"
  }
}

# Create ALB Target Group
resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group-${var.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher            = "200"
    path               = "/"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 2
  }

  tags = {
    Environment = var.env
    Name        = "web-tg-${var.env}"
  }
}

# Create ALB Listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port             = 80
  protocol         = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Attach EC2 instances to the target group
resource "aws_lb_target_group_attachment" "web_tg_attachment" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = element(aws_instance.ubuntu_ec2.*.id, count.index)
  port             = 80
}

# ── datasource.tf ────────────────────────────────────
data "aws_caller_identity" "current" {}
data "aws_subnets" "subnets" {}
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}


# ── instance.tf ────────────────────────────────────
resource "aws_instance" "ubuntu_ec2" {
    count = var.count_instance
    ami = data.aws_ami.latest_ubuntu.id
    instance_type = var.instance_type
    key_name = var.key_name
    user_data = file("${path.module}/install-nginx.sh")
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    tags = {
        Name = "ec2-instance-${count.index + 1}-alb-${var.env}"
    }
}



# ── sg.tf ────────────────────────────────────
resource "aws_security_group" "web_sg" {
  name = "sg"
  description = "An example security group for Terraform"

  dynamic "ingress" {
    for_each = [22, 80, 443, 8080]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    }

    ingress {
        description     = "HTTP from ALB"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg-group-alb-${var.env}"
    }
}