I'll help you create a Terraform configuration for a VPC with multiple public subnets and internet access. This configuration will:

1. Create a VPC in AWS
2. Create 3 public subnets across different availability zones
3. Create an Internet Gateway
4. Create a Route Table for public access
5. Associate the public subnets with the route table

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
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

# Create public subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
</iac_template>

This Terraform configuration creates:
1. A VPC with CIDR block 10.0.0.0/16
2. Three public subnets in different availability zones with CIDR blocks 10.0.1.0/24, 10.0.2.0/24, and 10.0.3.0/24
3. An Internet Gateway attached to the VPC
4. A public route table with a route to the Internet Gateway
5. Associations between the public subnets and the public route table

The configuration uses variables with default values for the VPC and subnet CIDR blocks, making it flexible for different environments. The public subnets are automatically distributed across available Availability Zones in the selected region (us-west-2). Each public subnet is configured to automatically assign public IP addresses to instances launched within them.