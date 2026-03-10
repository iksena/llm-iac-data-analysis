# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/terraform-ansible/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16"
    }
  }
}

# ── variables.tf ────────────────────────────────────
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Owner       = "Valerii Vasianovych"
    Environment = "Development"
  }
}

locals {
  vpc_id           = "vpc-0f47deecc163757a6"
  subnet_id        = "subnet-001cbe6a01612ea6c"
  ssh_user         = "ubuntu"
  key_name         = "ServersKey"
  private_key_path = "~/ssh_key_pairs/aws/ServersKey.pem"
}

# ── outputs.tf ────────────────────────────────────
output "region" {
  value = var.region
}

output "aws_caller_identity" {
    value = data.aws_caller_identity.current.id
}

output "vpc_id" {
  value = local.vpc_id
}

output "instance_id" {
  value = aws_instance.webserver.id
}

output "instance_public_ip" {
  value = aws_instance.webserver.public_ip
}

# ── datasource.tf ────────────────────────────────────
data "aws_caller_identity" "current" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}



# ── instance.tf ────────────────────────────────────
provider "aws" {
  region = var.region
}

resource "aws_security_group" "webserver-sg" {
  name   = "webserver-sg"
  vpc_id = local.vpc_id

  dynamic "ingress" {
    for_each = [22, 80, 443]
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

resource "aws_instance" "webserver" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = local.subnet_id
  associate_public_ip_address = true
  key_name                    = local.key_name
  security_groups             = [aws_security_group.webserver-sg.id]

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.webserver.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.webserver.public_ip}, --private-key ${local.private_key_path} nginx-playbook.yaml"
  }

  depends_on = [aws_security_group.webserver-sg]

  tags = merge(var.common_tags, {
    Name    = "WebServer Instance in ${var.region}"
    Project = "Terraform with Ansible"
  })
}