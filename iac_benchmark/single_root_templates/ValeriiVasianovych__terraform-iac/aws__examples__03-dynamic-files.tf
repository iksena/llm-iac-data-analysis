# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket         = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terrafrom-tfstate-dynamodb"
    encrypt        = true
    key            = "aws/tfstates/dynamic-files/terraform.tfstate"
    region         = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}


# ── variables.tf ────────────────────────────────────
variable "aws_region" {
    description = "Define region"
    type        = string
    default     = "us-east-1"
}

variable "instance_type" {
    description = "Define instance type"
    type        = string
    default     = "t2.micro"
}

variable "common_tags" {
    description = "Tags to apply to all resources"
    type        = map(string)
    default     = {
        Owner       = "Valerii Vasianovych"
        Project     = "AWS EC2 Ubuntu Instance Creation"
        Environment = "Development"
    }
}

variable "allow_security_groups_ports" {
    description = "The ports to open on the security group"
    type        = list(number)
    default     = [22, 80, 443]
}

# ── datasource.tf ────────────────────────────────────
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_ami" "latest_ubuntu" {
  owners     = ["099720109477"]
  most_recent = true
  filter {
    name  = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# ── dynamic-user-data.tf ────────────────────────────────────
resource "aws_instance" "dynamic_template_server" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.sg_rule.id]
  user_data = templatefile("template.sh.tpl", {
    f_name  = "Valerii"
    l_name  = "Vasianovych"
    email   = "valerii.vasianovych.2003@gmail.com"
    age     = "20"
    team = ["Marcin", "Anna", "Krzysztof"]
  })

  tags = merge(var.common_tags, {
    Name = "Dynamic Template Ubuntu Instance"
    Year = 2024})
  }

# ── security_group.tf ────────────────────────────────────
resource "aws_security_group" "sg_rule" {
  name        = "sg_rule"
  description = "Allow HTTP and HTTPS and SSH inbound traffic"

  dynamic "ingress" {
    for_each = var.allow_security_groups_ports

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
}