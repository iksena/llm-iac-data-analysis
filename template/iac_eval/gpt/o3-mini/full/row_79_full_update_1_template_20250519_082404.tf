Description:
This Terraform configuration sets up an AWS Route 53 hosted zone for the domain "example53.com" and creates a non-alias Route 53 record resource within that zone. The record is defined as an A record with a specified TTL and points to a sample IP address. The configuration includes the AWS provider declaration using a default region ("us-east-1") and variables with default values as necessary.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

resource "aws_route53_zone" "example_zone" {
  name = "example53.com"
}

resource "aws_route53_record" "example_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "www"
  type    = "A"
  ttl     = 300

  records = ["192.0.2.44"]
}
</iac_template>