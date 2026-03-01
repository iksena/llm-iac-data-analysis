To fulfill the business need, we will create a Terraform configuration that sets up an egress-only internet gateway for a specified VPC. This gateway will allow instances within the VPC that have IPv6 addresses to initiate outbound connections to the internet while preventing any inbound connections. We will define the necessary AWS provider configuration, create a VPC, and then associate the egress-only internet gateway with this VPC.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "example_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_egress_only_internet_gateway" "example_egress_gateway" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
}

resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.example_egress_gateway.id
  }
}

resource "aws_route_table_association" "example_route_table_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}
```
</iac_template>

This configuration includes:
- An AWS provider configured for the `us-west-2` region.
- A VPC with a CIDR block of `10.0.0.0/16`.
- An egress-only internet gateway associated with the VPC.
- A subnet within the VPC.
- A route table with a route for IPv6 traffic that uses the egress-only internet gateway.
- An association of the route table with the subnet.