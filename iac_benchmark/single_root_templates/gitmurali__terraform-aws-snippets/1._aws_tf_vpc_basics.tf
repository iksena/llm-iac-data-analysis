# ── main.tf ────────────────────────────────────

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "r" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  depends_on             = [aws_route_table.rt]
}

resource "aws_route_table_association" "rt-association" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

locals {
  ports_in = [
    443,
    80,
    22
  ]
  ports_out = [
    0
  ]
}

resource "aws_security_group" "allow_sgs" {
  name        = "dev_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = toset(local.ports_in)
    content {
      description      = "HTTPS from VPC"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = toset(local.ports_out)
    content {
      from_port        = egress.value
      to_port          = egress.value
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "allow_sgs"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "mykey"
  public_key = file("mykey.pub")
}


# ── outputs.tf ────────────────────────────────────
output "dev_id" {
  value = aws_instance.MyEc2Instance.public_ip
}

# ── providers.tf ────────────────────────────────────
# this provides configuration to aws
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# provides the information to access aws specifically
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}


# ── datasources.tf ────────────────────────────────────
data "aws_ami" "example" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "MyEc2Instance" {
  ami                    = data.aws_ami.example.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.auth.id
  vpc_security_group_ids = ["${aws_security_group.allow_sgs.id}"]
  subnet_id              = aws_subnet.main.id
  user_data              = file("${path.module}/userdata.tpl")

  root_block_device { 
    volume_size = 10
  }

  tags = {
    Name = "dev-node"
  }
}