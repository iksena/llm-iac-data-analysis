Below is a description and a complete Terraform HCL configuration that deploys two VPCs and a private Route 53 hosted zone initially associated with the primary VPC. Then an aws_route53_zone_association resource is used to associate the same hosted zone with the secondary VPC.

The configuration does the following:
1. Sets up an AWS provider in the "us-east-1" region.
2. Creates a primary VPC (CIDR 10.0.0.0/16) and a secondary VPC (CIDR 10.1.0.0/16).
3. Creates a private hosted zone for the domain "example.com" that is initially associated with the primary VPC.
4. Uses the aws_route53_zone_association resource to associate the hosted zone with the secondary VPC.
All variables have default values and the configuration is deployable.

<iac_template>
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
</iac_template>