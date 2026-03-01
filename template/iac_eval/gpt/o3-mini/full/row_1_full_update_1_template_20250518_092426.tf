Description:
This Terraform program deploys two VPCs in the us-east-1 region. It creates a private Route 53 hosted zone associated with the primary VPC. In addition, it defines a Route 53 zone association resource that associates the same private hosted zone with a secondary VPC. This setup demonstrates how additional VPCs can be associated with an existing private hosted zone. All required resources (VPCs, hosted zone, and zone association) are declared, and all variables are provided with default values.

<iac_template>
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

# Secondary VPC to be associated later with the private hosted zone
resource "aws_vpc" "secondary" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "SecondaryVPC"
  }
}

# Private Route 53 Hosted Zone associated with primary VPC
resource "aws_route53_zone" "private_zone" {
  name       = "example.internal"
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
  vpc_id  = aws_vpc.secondary.id
  vpc_region = "us-east-1"
}
</iac_template>