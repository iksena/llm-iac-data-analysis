The Terraform program will create an AWS Virtual Private Cloud (VPC) with a specified CIDR block and enable IPv6 support. The configuration will include the necessary provider setup for AWS, and the VPC will be configured with both an IPv4 CIDR block and an IPv6 CIDR block. The IPv6 CIDR block will be automatically assigned by AWS. This setup will allow for dual-stack networking within the VPC.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "example-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.example_vpc.id
}

output "ipv6_cidr_block" {
  value = aws_vpc.example_vpc.ipv6_cidr_block
}
```
</iac_template>