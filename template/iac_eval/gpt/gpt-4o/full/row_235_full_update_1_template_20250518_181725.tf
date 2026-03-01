The Terraform program will create an AWS Virtual Private Cloud (VPC) with an IPv6 CIDR block. It will also create an Egress-Only Internet Gateway and attach it to the VPC. This setup allows instances within the VPC to access the internet over IPv6 while preventing inbound traffic from the internet.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  ipv6_cidr_block = aws_vpc_ipv6_cidr_block_association.main.ipv6_cidr_block
}

resource "aws_vpc_ipv6_cidr_block_association" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}
```
</iac_template>