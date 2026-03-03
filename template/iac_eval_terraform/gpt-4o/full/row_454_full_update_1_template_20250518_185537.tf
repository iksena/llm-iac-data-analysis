To establish a VPC peering connection between two AWS VPCs named "peer" and "base," we will create a Terraform configuration that defines both VPCs and the peering connection. The peering connection will be named "pike" and tagged with `pike = "permissions"`. We will also ensure that the necessary route table updates are made to allow communication between the two VPCs. The configuration will include the AWS provider setup and necessary IAM roles.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "peer" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "peer"
  }
}

resource "aws_vpc" "base" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "base"
  }
}

resource "aws_vpc_peering_connection" "pike" {
  vpc_id        = aws_vpc.peer.id
  peer_vpc_id   = aws_vpc.base.id
  auto_accept   = true

  tags = {
    Name = "pike"
    pike = "permissions"
  }
}

resource "aws_route" "peer_to_base" {
  route_table_id            = aws_vpc.peer.main_route_table_id
  destination_cidr_block    = aws_vpc.base.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.pike.id
}

resource "aws_route" "base_to_peer" {
  route_table_id            = aws_vpc.base.main_route_table_id
  destination_cidr_block    = aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.pike.id
}
```
</iac_template>

This configuration sets up two VPCs, establishes a peering connection between them, and updates the route tables to allow traffic to flow between the VPCs. The peering connection is tagged appropriately to indicate its purpose.