provider "aws" {
  region = "us-east-1"
}

# Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for VPC"
  type        = string
  default     = "main-vpc"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# Create DHCP Options Set
resource "aws_vpc_dhcp_options" "custom_dhcp_options" {
  domain_name          = "windomain.local"
  domain_name_servers  = ["192.168.56.102", "8.8.8.8"]
  netbios_name_servers = ["192.168.56.102"]

  tags = {
    Name = "custom-dhcp-options"
  }
}

# Associate DHCP Options Set with VPC
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.custom_dhcp_options.id
}

# Output
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "dhcp_options_id" {
  description = "ID of the created DHCP Options Set"
  value       = aws_vpc_dhcp_options.custom_dhcp_options.id
}