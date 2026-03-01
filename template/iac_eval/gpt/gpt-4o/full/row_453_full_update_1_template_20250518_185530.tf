The Terraform program will establish a VPC peering connection between two AWS VPCs. The first VPC, named "peer," will have a CIDR block of 10.0.0.0/24, and the second VPC, named "base," will have a CIDR block of 10.1.0.0/24. A VPC peering connection named "pike" will be created to enable communication between these two VPCs. The necessary route table updates will be made to ensure traffic can flow between the VPCs over the peering connection. The configuration will include the AWS provider setup and necessary IAM roles.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "peer" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "peer"
  }
}

resource "aws_vpc" "base" {
  cidr_block = "10.1.0.0/24"
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
  }
}

resource "aws_route" "peer_to_base" {
  route_table_id         = aws_vpc.peer.main_route_table_id
  destination_cidr_block = aws_vpc.base.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.pike.id
}

resource "aws_route" "base_to_peer" {
  route_table_id         = aws_vpc.base.main_route_table_id
  destination_cidr_block = aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.pike.id
}
```
</iac_template>