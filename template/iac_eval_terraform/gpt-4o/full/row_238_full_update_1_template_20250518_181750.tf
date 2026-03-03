To fulfill the business need, we will create two AWS Virtual Private Clouds (VPCs) and establish a VPC peering connection between them. Each VPC will have its own CIDR block, and we will configure the necessary route tables to allow traffic to flow between the two VPCs over the peering connection. We will also create the necessary IAM roles and policies to manage the resources.

Here is the Terraform HCL configuration:

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC1"
  }
}

resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "VPC2"
  }
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id        = aws_vpc.vpc1.id
  peer_vpc_id   = aws_vpc.vpc2.id
  auto_accept   = true

  tags = {
    Name = "VPC1-to-VPC2"
  }
}

resource "aws_route" "vpc1_to_vpc2" {
  route_table_id            = aws_vpc.vpc1.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "vpc2_to_vpc1" {
  route_table_id            = aws_vpc.vpc2.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
```

</iac_template>

This configuration sets up two VPCs with CIDR blocks `10.0.0.0/16` and `10.1.0.0/16`. It establishes a peering connection between them and updates the main route tables of each VPC to allow traffic to flow between them. The peering connection is automatically accepted.