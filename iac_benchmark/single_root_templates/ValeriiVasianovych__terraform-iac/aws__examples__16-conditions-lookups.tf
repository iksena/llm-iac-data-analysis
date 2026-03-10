# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/conditions/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16"
    }
  }
}
provider "aws" {
  region = var.region
}

# ── variables.tf ────────────────────────────────────
variable "region" {
  description = "Region variable"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment variable"
  type        = string
}

variable "sg_ports" {
  description = "Allow security group ports"
  type        = list(number)
  default     = [80, 443, 22]
}

variable "monitoring_value" {
  description = "Enable monitoring"
  type        = bool
  default     = false
}

# Lookup
variable "instance_size" {
  default = {
    "dev"     = "t2.micro"
    "prod"    = "t3.medium"
    "staging" = "t2.large"
  }
}

variable "sg_lookup_ports" {
  default = {
    "dev"  = [80, 443]
    "prod" = [80, 443, 22]
  }
}

# ── conditions.tf ────────────────────────────────────
resource "aws_instance" "ec2_instance_conditions" {
  count                  = (var.env == "Development" ? 1 : 3)
  ami                    = "data.aws_ami.latest_ubuntu"
  instance_type          = (var.env == "Development" ? "t2.micro" : "t3.medium")
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.sg_conditions.id]
  monitoring             = (var.env == "Development" ? false : true)

  tags = {
    Region = var.region
    Owner  = "Valerii Vasianovych"
    Env    = var.env
  }
}

resource "aws_security_group" "sg_conditions" {
  name        = "Web Security Group"
  description = "Securit Group for instance"
  dynamic "ingress" {
    for_each = (var.env == "Development" ? [80, 22] : var.sg_ports)
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
    Region = var.region
    Owner  = "Valerii Vasianovych"
    Env    = var.env
  }
}

# ── datasource.tf ────────────────────────────────────
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# ── lookups.tf ────────────────────────────────────
resource "aws_instance" "ec2_instance_lookups" {
  ami = "data.aws_ami.latest_ubuntu"
  # instance_type = lookup(var.instance_size, "staging")
  instance_type          = (var.env == "Development" ? var.instance_size["dev"] : var.instance_size["prod"])
  vpc_security_group_ids = [aws_security_group.sg_lookups.id]
  key_name               = "ServerKey"
  tags = {
    Region        = var.region
    Owner         = "Valerii Vasianovych"
    Env           = var.env
    Instance-Type = (var.env == "Development" ? var.instance_size["dev"] : var.instance_size["prod"])
  }
}

resource "aws_security_group" "sg_lookups" {
  name        = "Web Security Group"
  description = "Securit Group for instance"
  dynamic "ingress" {
    for_each = (var.env == "Development" ? var.sg_lookup_ports["dev"] : var.sg_lookup_ports["prod"])
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
    Region = var.region
    Owner  = "Valerii Vasianovych"
    Env    = var.env
  }
}