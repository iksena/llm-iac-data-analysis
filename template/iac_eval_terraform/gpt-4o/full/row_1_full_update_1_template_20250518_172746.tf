To configure a valid Route 53 zone association resource, we will create a Terraform configuration that sets up an AWS VPC and a Route 53 private hosted zone. We will then associate the VPC with the Route 53 private hosted zone. This setup allows the VPC to resolve DNS queries for the domain specified in the private hosted zone.

Below is the Terraform HCL configuration for this setup:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_route53_zone" "example" {
  name = "example.com"
  vpc {
    vpc_id = aws_vpc.example.id
  }
}

resource "aws_route53_zone_association" "example" {
  zone_id = aws_route53_zone.example.zone_id
  vpc_id  = aws_vpc.example.id
}
```
</iac_template>

This configuration includes:
- An AWS provider configured for the `us-east-1` region.
- A VPC resource with a CIDR block of `10.0.0.0/16`.
- A Route 53 private hosted zone for the domain `example.com`.
- An association between the VPC and the Route 53 private hosted zone, allowing DNS queries within the VPC to resolve using the private hosted zone.