I'll help you create a Terraform configuration that sets up an AWS VPC with an Internet Gateway and a custom route table. This configuration will:

1. Create a VPC with a specified CIDR block
2. Create an Internet Gateway and attach it to the VPC
3. Create a custom route table
4. Add a route to the Internet Gateway for internet-bound traffic
5. Use the AWS provider with a specific region

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create Custom Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-rt"
  }
}

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output the Internet Gateway ID
output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

# Output the Route Table ID
output "route_table_id" {
  value = aws_route_table.main.id
}
</iac_template>

This Terraform configuration creates:
1. A VPC with CIDR block 10.0.0.0/16
2. An Internet Gateway attached to the VPC
3. A custom route table with a route that directs all internet-bound traffic (0.0.0.0/0) through the Internet Gateway
4. Appropriate tags for each resource for better identification
5. Outputs for the IDs of created resources

The configuration enables DNS hostnames and DNS support in the VPC for better network functionality. All resources are properly linked together using resource references, and the configuration is complete and deployable. The AWS provider is set to the us-west-2 region, but you can modify this according to your needs.