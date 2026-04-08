terraform {
  backend "s3" {
    bucket       = "terraform-states-vv"
    encrypt      = true
    key          = "tasks/aws-ec2/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "vpc-transit-gw"
    }
  }
}

module "vpc" {
  for_each = var.vpc_cidr
  source   = "terraform-aws-modules/vpc/aws"
  cidr     = each.value
  name     = each.key

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = []
  public_subnets  = [local.public_subnet_cidrs[each.key]]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    VPC_Name  = "${each.key}"
  }
}

resource "aws_security_group" "sg" {
  for_each = module.vpc

  vpc_id      = each.value.vpc_id
  name        = "${each.key}-sg"
  description = "Allow ICMP, SSH, HTTP, HTTPS"

  dynamic "ingress" {
    for_each = [22, 80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu_ec2" {
  for_each = local.ec2_map

  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = [each.value.sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "ec2-${each.key}"
  }
}

resource "aws_ec2_transit_gateway" "tg" {
  region                         = var.region
  description                    = "Transit Gateway for VPCs"
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "TransitGateway"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_attachment" {
  for_each = module.vpc

  transit_gateway_id = aws_ec2_transit_gateway.tg.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.public_subnets

  tags = {
    Name = "${each.key}-attachment"
  }
}

# | **VPC** | **Destination (CIDR)** | **Target / Attachment** |
# | ------- | ---------------------- | ----------------------- |
# | VPC1    | 10.20.0.0/16           | TGW Attachment к VPC2   |
# | VPC1    | 10.30.0.0/16           | TGW Attachment к VPC3   |
# | VPC2    | 10.10.0.0/16           | TGW Attachment к VPC1   |
# | VPC2    | 10.30.0.0/16           | TGW Attachment к VPC3   |
# | VPC3    | 10.10.0.0/16           | TGW Attachment к VPC1   |
# | VPC3    | 10.20.0.0/16           | TGW Attachment к VPC2   |
