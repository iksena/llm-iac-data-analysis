Below is a description of the Terraform program we’re about to build:

Description:
This Terraform configuration deploys AWS infrastructure to configure a valid Route 53 zone association resource. In this example, we create two VPCs – one (the primary VPC) is used to create a private hosted zone for the domain (example.com) and the second (the secondary VPC) will be associated with the already created private hosted zone using the aws_route53_zone_association resource. The configuration includes a provider block for AWS in the specified region and all variables have default values. No undeclared resources or variables are present, ensuring the configuration is deployable.

Below is the complete Terraform HCL program:

<iac_template>
provider "aws" {
  region = var.aws_region
}

# Variable definitions
variable "aws_region" {
  description = "AWS region to deploy resources"
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

variable "zone_name" {
  description = "The domain name for the private hosted zone"
  type        = string
  default     = "example.com"
}

# Create the primary VPC which is initially associated with the private hosted zone
resource "aws_vpc" "primary" {
  cidr_block           = var.primary_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Primary VPC"
  }
}

# Create a secondary VPC to later associate with the private hosted zone
resource "aws_vpc" "secondary" {
  cidr_block           = var.secondary_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Secondary VPC"
  }
}

# Create a private Route 53 hosted zone associated with the primary VPC
resource "aws_route53_zone" "private_zone" {
  name         = var.zone_name
  private_zone = true

  vpc {
    vpc_id     = aws_vpc.primary.id
    vpc_region = var.aws_region
  }

  tags = {
    Environment = "dev"
  }
}

# Associate the secondary VPC with the existing private hosted zone
resource "aws_route53_zone_association" "secondary_association" {
  zone_id = aws_route53_zone.private_zone.zone_id
  vpc_id  = aws_vpc.secondary.id
}
</iac_template>