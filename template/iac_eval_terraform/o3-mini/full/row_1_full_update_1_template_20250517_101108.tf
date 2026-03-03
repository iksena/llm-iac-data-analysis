Below is the complete Terraform HCL program. In this example we create two VPCs. The private Route 53 hosted zone is initially associated with the primary VPC (using the inline vpc block on the hosted zone resource) and then we associate a second VPC with the same zone by using an aws_route53_zone_association resource. This meets the requirement to configure a valid Route 53 zone association resource.

<iac_template>
provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Create the primary VPC
resource "aws_vpc" "primary" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "PrimaryVPC"
  }
}

# Create a secondary VPC that will be associated with the private hosted zone later
resource "aws_vpc" "secondary" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "SecondaryVPC"
  }
}

# Create a private hosted zone that is initially associated with the primary VPC
resource "aws_route53_zone" "private" {
  name         = "example.internal"
  private_zone = true

  vpc {
    vpc_id     = aws_vpc.primary.id
    vpc_region = var.region
  }

  tags = {
    Environment = "dev"
  }
}

# Associate the secondary VPC with the existing private hosted zone
resource "aws_route53_zone_association" "secondary_association" {
  zone_id   = aws_route53_zone.private.zone_id
  vpc_id    = aws_vpc.secondary.id
  vpc_region = var.region
}
</iac_template>