provider "aws" {
  region = "us-west-2"  # You can modify the region as needed
}

# Variables
variable "vpc_id" {
  description = "ID of the VPC to associate DHCP options with"
  type        = string
  default     = "vpc-12345678" # Replace with your actual VPC ID
}

# Create DHCP Options Set
resource "aws_vpc_dhcp_options" "pike" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
  
  tags = {
    Name        = "pike"
    permissions = "true"
  }
}

# Associate DHCP Options with VPC
resource "aws_vpc_dhcp_options_association" "pike_association" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.pike.id

  tags = {
    permissions = "true"
  }
}