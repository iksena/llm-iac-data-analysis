I'll help you create a Terraform configuration that sets up two subnets and groups them into a subnet group for an AWS Neptune cluster. This configuration will:

1. Create a VPC to host the subnets
2. Create two subnets in different availability zones
3. Create a Neptune subnet group using these subnets
4. Include necessary networking components (Internet Gateway and Route Table)

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  type        = map(string)
  default = {
    subnet1 = "10.0.1.0/24"
    subnet2 = "10.0.2.0/24"
  }
}

# Create VPC
resource "aws_vpc" "neptune_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "neptune-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "neptune_igw" {
  vpc_id = aws_vpc.neptune_vpc.id

  tags = {
    Name = "neptune-igw"
  }
}

# Create Route Table
resource "aws_route_table" "neptune_rt" {
  vpc_id = aws_vpc.neptune_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.neptune_igw.id
  }

  tags = {
    Name = "neptune-rt"
  }
}

# Create Subnets
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = var.subnet_cidrs["subnet1"]
  availability_zone = "us-west-2a"

  tags = {
    Name = "neptune-subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = var.subnet_cidrs["subnet2"]
  availability_zone = "us-west-2b"

  tags = {
    Name = "neptune-subnet-2"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.neptune_rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.neptune_rt.id
}

# Create Neptune Subnet Group
resource "aws_neptune_subnet_group" "neptune_subnet_group" {
  name        = "neptune-subnet-group"
  description = "Neptune subnet group"
  subnet_ids  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "neptune-subnet-group"
  }
}
</iac_template>

This Terraform configuration creates:
1. A VPC with CIDR block 10.0.0.0/16
2. Two subnets in different availability zones (us-west-2a and us-west-2b)
3. An Internet Gateway for internet connectivity
4. A Route Table with appropriate routes
5. Route Table associations with both subnets
6. A Neptune subnet group containing both subnets

The configuration uses variables with default values for the CIDR blocks, making it flexible for different deployment scenarios. The subnets are properly tagged and organized within the VPC, and the Neptune subnet group is created to be used with Neptune clusters.

You can deploy this configuration as is, or modify the CIDR blocks by providing different values for the variables. The configuration is complete and deployable in the us-west-2 (Oregon) region.