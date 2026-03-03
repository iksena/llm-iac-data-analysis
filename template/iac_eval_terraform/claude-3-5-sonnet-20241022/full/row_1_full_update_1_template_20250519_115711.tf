I'll help you create a Terraform configuration to set up a Route 53 zone association resource. This configuration will associate a VPC with a private hosted zone in Route 53, enabling DNS resolution within the VPC.

The configuration will:
1. Create a VPC
2. Create a private hosted zone in Route 53
3. Create a zone association between the VPC and the private hosted zone

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create Private Hosted Zone
resource "aws_route53_zone" "private" {
  name = "example.internal"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = {
    Environment = "private"
  }
}

# Create Zone Association
resource "aws_route53_zone_association" "private" {
  zone_id = aws_route53_zone.private.id
  vpc_id  = aws_vpc.main.id
}

# Output the Zone ID
output "zone_id" {
  value = aws_route53_zone.private.id
}

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}
</iac_template>

This Terraform configuration:
1. Sets up the AWS provider in the us-east-1 region
2. Creates a VPC with DNS support enabled
3. Creates a private hosted zone named "example.internal"
4. Associates the VPC with the private hosted zone using aws_route53_zone_association
5. Includes outputs for both the zone ID and VPC ID

The configuration is complete and deployable. It includes all necessary resources and their dependencies. The private hosted zone will be accessible only within the specified VPC, which is a common setup for internal DNS resolution in AWS environments.