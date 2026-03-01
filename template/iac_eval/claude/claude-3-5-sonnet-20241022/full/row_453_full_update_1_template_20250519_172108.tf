I'll help you create a Terraform configuration that establishes a VPC peering connection between two VPCs in AWS. Here's what the configuration will do:

1. Create two VPCs ("peer" and "base") with specified CIDR blocks
2. Create a VPC peering connection between these VPCs
3. Accept the VPC peering connection
4. Update route tables in both VPCs to enable traffic flow

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create the peer VPC
resource "aws_vpc" "peer" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "peer-vpc"
  }
}

# Create the base VPC
resource "aws_vpc" "base" {
  cidr_block           = "10.1.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "base-vpc"
  }
}

# Create VPC peering connection
resource "aws_vpc_peering_connection" "pike" {
  peer_vpc_id = aws_vpc.peer.id
  vpc_id      = aws_vpc.base.id
  auto_accept = true

  tags = {
    Name = "pike-peering"
  }
}

# Create route table for peer VPC
resource "aws_route_table" "peer_route_table" {
  vpc_id = aws_vpc.peer.id

  route {
    cidr_block                = aws_vpc.base.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.pike.id
  }

  tags = {
    Name = "peer-route-table"
  }
}

# Create route table for base VPC
resource "aws_route_table" "base_route_table" {
  vpc_id = aws_vpc.base.id

  route {
    cidr_block                = aws_vpc.peer.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.pike.id
  }

  tags = {
    Name = "base-route-table"
  }
}

# Associate route table with peer VPC
resource "aws_main_route_table_association" "peer_route_association" {
  vpc_id         = aws_vpc.peer.id
  route_table_id = aws_route_table.peer_route_table.id
}

# Associate route table with base VPC
resource "aws_main_route_table_association" "base_route_association" {
  vpc_id         = aws_vpc.base.id
  route_table_id = aws_route_table.base_route_table.id
}
</iac_template>

This Terraform configuration:
1. Sets up the AWS provider in the us-west-2 region
2. Creates two VPCs with the specified CIDR blocks
3. Establishes a VPC peering connection named "pike" between the VPCs
4. Creates and configures route tables for both VPCs to route traffic through the peering connection
5. Associates the route tables with their respective VPCs

The configuration enables DNS support and DNS hostnames for both VPCs to ensure proper name resolution. The auto_accept parameter is set to true in the peering connection to automatically accept the peering request. The route tables are configured to route traffic between the VPCs through the peering connection.

This configuration is complete and deployable, with all necessary resources properly declared and configured.