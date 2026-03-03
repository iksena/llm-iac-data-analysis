Below is an improved version of the Terraform program. The change removes the unsupported private_zone argument. When you provide a VPC block, the zone is automatically considered private. Replace the previous version with this updated template.

<iac_template>
terraform {
  required_version = ">= 1.3.0"

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
  description = "AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "primary_vpc_cidr" {
  description = "CIDR block for the primary VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for the secondary VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "private_zone_domain" {
  description = "Domain for the private Route 53 hosted zone."
  type        = string
  default     = "example.com"
}

# Create the primary VPC
resource "aws_vpc" "primary" {
  cidr_block = var.primary_vpc_cidr

  tags = {
    Name = "Primary-VPC"
  }
}

# Create the secondary VPC
resource "aws_vpc" "secondary" {
  cidr_block = var.secondary_vpc_cidr

  tags = {
    Name = "Secondary-VPC"
  }
}

# Create a private hosted zone by including a VPC block (no need for private_zone argument)
resource "aws_route53_zone" "private_zone" {
  name = var.private_zone_domain

  vpc {
    vpc_id     = aws_vpc.primary.id
    vpc_region = var.aws_region
  }

  tags = {
    Environment = "Dev"
  }
}

# Associate the private hosted zone with the secondary VPC
resource "aws_route53_zone_association" "secondary_association" {
  zone_id    = aws_route53_zone.private_zone.zone_id
  vpc_id     = aws_vpc.secondary.id
  vpc_region = var.aws_region
}
</iac_template>