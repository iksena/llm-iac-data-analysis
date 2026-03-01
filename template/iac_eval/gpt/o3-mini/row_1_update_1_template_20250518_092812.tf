terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "primary_vpc_cidr" {
  description = "CIDR block for the primary VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for the secondary VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "private_zone_domain" {
  description = "Domain name for the private Route 53 zone"
  type        = string
  default     = "example.com"
}

# Primary VPC creation
resource "aws_vpc" "primary" {
  cidr_block = var.primary_vpc_cidr

  tags = {
    Name = "Primary-VPC"
  }
}

# Secondary VPC creation
resource "aws_vpc" "secondary" {
  cidr_block = var.secondary_vpc_cidr

  tags = {
    Name = "Secondary-VPC"
  }
}

# Create a private hosted zone associated with the primary VPC
resource "aws_route53_zone" "private_zone" {
  name          = var.private_zone_domain
  private_zone  = true

  vpc {
    vpc_id     = aws_vpc.primary.id
    vpc_region = var.aws_region
  }

  tags = {
    Environment = "Dev"
  }
}

# Associate the hosted zone with the secondary VPC using a zone association resource
resource "aws_route53_zone_association" "private_zone_assoc" {
  zone_id  = aws_route53_zone.private_zone.zone_id
  vpc_id   = aws_vpc.secondary.id
  vpc_region = var.aws_region
}