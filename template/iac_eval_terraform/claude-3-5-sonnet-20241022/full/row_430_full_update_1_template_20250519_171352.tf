I'll help you create a Terraform configuration that sets up a VPC with dedicated tenancy, DNS support, and the required networking components. Here's what the configuration will do:

1. Creates a VPC with dedicated tenancy
2. Enables DNS hostnames and DNS support
3. Creates an Internet Gateway
4. Creates a Route Table
5. Associates the Route Table with the VPC
6. Adds a route for outbound internet access
7. Applies consistent tagging using a variable

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "environment_name" {
  description = "Name tag for all resources"
  type        = string
  default     = "dedicated-vpc"
}

# VPC Resource
resource "aws_vpc" "dedicated_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "dedicated"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.environment_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.dedicated_vpc.id

  tags = {
    Name = "${var.environment_name}-igw"
  }
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.dedicated_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.environment_name}-rt"
  }
}

# Main Route Table Association
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.dedicated_vpc.id
  route_table_id = aws_route_table.main.id
}

# Outputs
output "vpc_id" {
  value       = aws_vpc.dedicated_vpc.id
  description = "The ID of the VPC"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "The ID of the Internet Gateway"
}

output "route_table_id" {
  value       = aws_route_table.main.id
  description = "The ID of the Route Table"
}
</iac_template>

This Terraform configuration creates a fully functional VPC with dedicated tenancy and all the necessary components for internet connectivity. Here's a breakdown of what each resource does:

1. The provider block configures AWS as the cloud provider and sets the region to us-east-1.
2. A variable "environment_name" is defined with a default value of "dedicated-vpc" for consistent resource tagging.
3. The VPC is created with dedicated tenancy, DNS support, and DNS hostnames enabled.
4. An Internet Gateway is created and attached to the VPC.
5. A Route Table is created with a route to the Internet Gateway for outbound internet access (0.0.0.0/0).
6. The Route Table is set as the main route table for the VPC.
7. Output values are provided for the VPC ID, Internet Gateway ID, and Route Table ID.

All resources are properly tagged with the environment name, and the configuration is complete and deployable. The VPC is created with a CIDR block of 10.0.0.0/16, which provides plenty of IP addresses for future use.