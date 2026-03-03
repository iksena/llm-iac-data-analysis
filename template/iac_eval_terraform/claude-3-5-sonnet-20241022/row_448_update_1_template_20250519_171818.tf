provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create DHCP Options Set
resource "aws_vpc_dhcp_options" "custom_dhcp_options" {
  domain_name          = "windomain.local"
  domain_name_servers  = ["192.168.56.102", "8.8.8.8"]
  netbios_name_servers = ["192.168.56.102"]
  netbios_node_type    = 2

  tags = {
    Name = "custom-dhcp-options"
  }
}

# Associate DHCP Options Set with VPC
resource "aws_vpc_dhcp_options_association" "dhcp_association" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.custom_dhcp_options.id
}

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output the DHCP Options Set ID
output "dhcp_options_id" {
  value = aws_vpc_dhcp_options.custom_dhcp_options.id
}