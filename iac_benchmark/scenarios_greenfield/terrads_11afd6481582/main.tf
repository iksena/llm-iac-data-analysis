terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc[0].cidr_block
  instance_tenancy     = var.vpc[0].instance_tenancy
  enable_dns_hostnames = var.vpc[0].enable_dns_hostnames
  enable_dns_support   = var.vpc[0].enable_dns_support
  tags = {
    Name        = "${local.prefix}_${var.vpc[0].name}"
    Project     = var.project
    Envrionment = var.env
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_public[0].cidr_block
  availability_zone       = var.subnet_public[0].availability_zone
  map_public_ip_on_launch = var.subnet_public[0].map_public_ip_on_launch
  tags = {
    Name        = var.create_prefix_for_resources ? "${local.prefix}_${var.subnet_public[0].name}" : "${var.subnet_public[0].name}"
    Project     = var.project
    Envrionment = var.env
  }
}

resource "aws_security_group" "security_group" {
  name   = var.create_prefix_for_resources ? "${local.prefix}_${var.security_group[0].name}" : "${var.security_group[0].name}"
  vpc_id = aws_vpc.vpc.id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = var.create_prefix_for_resources ? "${local.prefix}_${var.security_group[0].name}" : "${var.security_group[0].name}"
    Project     = var.project
    Envrionment = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.route_table[0].cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block = var.route_table[0].ipv6_cidr_block
    gateway_id      = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = var.create_prefix_for_resources ? "${local.prefix}_${var.route_table[0].name}" : "${var.route_table[0].name}"
    Project     = var.project
    Envrionment = var.env
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_network_interface" "network_interface" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = var.network_interface[0].private_ips
  security_groups = [aws_security_group.security_group.id]
  tags = {
    Name        = "${local.prefix}_${var.network_interface[0].name}"
    Project     = var.project
    Envrionment = var.env
  }
}

locals {
  prefix = "${var.project}_${var.env}"
}
