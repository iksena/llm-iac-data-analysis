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
  region = "us-east-1"
}

# Primary VPC
resource "aws_vpc" "primary" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "PrimaryVPC"
  }
}

# Secondary VPC to be associated with the private hosted zone
resource "aws_vpc" "secondary" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "SecondaryVPC"
  }
}

# Private Route 53 Hosted Zone associated with the primary VPC
resource "aws_route53_zone" "private_zone" {
  name         = "example.internal"
  private_zone = true

  vpc {
    vpc_id = aws_vpc.primary.id
    region = "us-east-1"
  }

  tags = {
    Environment = "Dev"
  }
}

# Route 53 Zone Association: Associate the private hosted zone with the secondary VPC
resource "aws_route53_zone_association" "secondary_assoc" {
  zone_id = aws_route53_zone.private_zone.zone_id

  vpc {
    vpc_id     = aws_vpc.secondary.id
    vpc_region = "us-east-1"
  }
}
</iac_template>