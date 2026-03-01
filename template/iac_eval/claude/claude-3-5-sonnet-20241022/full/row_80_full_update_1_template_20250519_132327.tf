I'll help you create a Terraform configuration that sets up a Route 53 private hosted zone with a VPC association and a DNS record. The configuration will include:

1. A VPC resource (aws_vpc "main")
2. A Route 53 private hosted zone (aws_route53_zone "private_zone")
3. A Route 53 record in the private zone
4. VPC association with the private hosted zone

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
    Name = "main"
  }
}

# Create Route 53 Private Hosted Zone
resource "aws_route53_zone" "private_zone" {
  name = "internal.example53.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = {
    Environment = "private"
  }
}

# Create Route 53 Record
resource "aws_route53_record" "example" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "service.internal.example53.com"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.10"]
}
</iac_template>

This configuration:
1. Sets up the AWS provider in the us-east-1 region
2. Creates a VPC with DNS support enabled
3. Creates a private Route 53 hosted zone named "internal.example53.com" and associates it with the VPC
4. Creates an A record in the private hosted zone pointing to an internal IP address

The private hosted zone will only be accessible within the VPC. The A record created points to an example internal IP address (10.0.0.10) - you can modify this to point to your actual internal resource IP address.

All resources are fully declared and properly referenced. The configuration is deployable and follows AWS best practices for private DNS management.