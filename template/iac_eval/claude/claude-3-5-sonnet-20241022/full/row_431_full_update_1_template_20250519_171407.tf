I'll help you create a Terraform configuration that sets up a VPC with dedicated tenancy, DNS support, and internet connectivity in AWS. This configuration will:

1. Create a VPC with dedicated tenancy
2. Enable DNS hostnames and DNS support
3. Create an Internet Gateway
4. Create a route table for internet access
5. Associate the route table with the VPC
6. Apply consistent tagging using a variable

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Define variables
variable "environment_name" {
  description = "Name tag for all resources"
  type        = string
  default     = "dedicated-vpc"
}

# Create VPC
resource "aws_vpc" "dedicated_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "dedicated"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.environment_name
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.dedicated_vpc.id

  tags = {
    Name = "${var.environment_name}-igw"
  }
}

# Create Route Table
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

# Associate Route Table with VPC Main Route Table
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.dedicated_vpc.id
  route_table_id = aws_route_table.main.id
}

# Output the VPC ID
output "vpc_id" {
  value       = aws_vpc.dedicated_vpc.id
  description = "The ID of the VPC"
}

# Output the Internet Gateway ID
output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "The ID of the Internet Gateway"
}
</iac_template>

This Terraform configuration creates:

1. A VPC with dedicated tenancy, DNS support, and DNS hostnames enabled
2. An Internet Gateway attached to the VPC
3. A route table with a route to the internet (0.0.0.0/0) via the Internet Gateway
4. Associates the route table as the main route table for the VPC
5. All resources are tagged with the variable name (default: "dedicated-vpc")

The configuration uses the following CIDR and settings:
- VPC CIDR: 10.0.0.0/16
- Region: us-east-1
- Dedicated tenancy
- DNS support enabled
- DNS hostnames enabled

The configuration also includes outputs for the VPC ID and Internet Gateway ID for reference. You can deploy this configuration as-is, or customize the `environment_name` variable to change the resource tags.