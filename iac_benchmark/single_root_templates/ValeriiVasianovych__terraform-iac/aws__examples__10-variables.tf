# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terrafrom-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/variables/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# ── variables.tf ────────────────────────────────────
variable "region" {
  description = "The AWS region to launch the instance"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "allow_sg_ports" {
  description = "The ports to open on the security group"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "monitoring_value" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Owner       = "Valerii Vasianovych"
    Project     = "AWS Instance Creation"
    Environment = "Development"
  }
}

# ── outputs.tf ────────────────────────────────────
output "region" {
  value = data.aws_region.current.name
}

output "describe_region" {
  value = data.aws_region.current
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "subnet_ids" {
  value = data.aws_subnet_ids.default.ids
}

# ── datasource.tf ────────────────────────────────────
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_vpc" "default" {}
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# ── eip.tf ────────────────────────────────────
resource "aws_eip" "static_ip" {
  instance = aws_instance.instance_ubuntu.id
  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]} Server IP"
  })
}


# ── instance.tf ────────────────────────────────────
resource "aws_instance" "instance_ubuntu" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type # Instance type, default is t2.micro
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = file("script.sh")
  monitoring             = var.monitoring_value # Monitoring, default is false

  tags = merge(var.common_tags, { # Tags to apply to the instance
    Name = "Ubuntu Instance"
  })
}

# ── security-group.tf ────────────────────────────────────

resource "aws_security_group" "web_sg" {
  name        = "Web Security Group"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allow_sg_ports # List of ports to open, default is [22, 80, 443]
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
  tags = merge(var.common_tags, {
    Name = "Web Security Group"
  })
}