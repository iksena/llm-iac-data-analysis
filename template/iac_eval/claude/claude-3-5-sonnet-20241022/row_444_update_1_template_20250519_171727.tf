provider "aws" {
  region = "us-west-2"  # You can modify the region as needed
}

# Create VPC (since we need one to associate DHCP options)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create DHCP Options Set
resource "aws_vpc_dhcp_options" "pike" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]

  tags = {
    Name = "pike"
  }
}

# Associate DHCP Options Set with VPC
resource "aws_vpc_dhcp_options_association" "pike_association" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.pike.id
}