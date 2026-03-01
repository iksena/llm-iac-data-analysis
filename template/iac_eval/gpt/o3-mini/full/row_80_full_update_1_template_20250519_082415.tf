Below is a description of the Terraform program followed by the complete deployable Terraform HCL configuration.

Description:
• We configure the AWS provider to use "us-east-1".
• An AWS VPC resource ("main") is defined with a CIDR block of 10.0.0.0/16 and tagged with "Name"="main".
• An AWS Route 53 private hosted zone resource ("private_zone") is created with the zone name "internal.example53.com" and is attached to the “main” VPC.
• A non-alias AWS Route 53 record is created (an A record with a TTL of 300 seconds and a sample IP "10.0.0.20") that uses the hosted zone "private_zone". 

Below is the complete Terraform HCL configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_route53_zone" "private_zone" {
  name          = "internal.example53.com"
  comment       = "Private hosted zone for internal use"
  private_zone  = true

  vpc {
    vpc_id     = aws_vpc.main.id
    vpc_region = "us-east-1"
  }
}

resource "aws_route53_record" "non_alias_record" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "app.internal.example53.com"  # Fully qualified name for the record
  type    = "A"
  ttl     = 300
  records = ["10.0.0.20"]
}
</iac_template>