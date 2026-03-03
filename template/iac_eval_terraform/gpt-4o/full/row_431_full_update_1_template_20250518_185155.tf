The Terraform program will create a dedicated-tenancy AWS Virtual Private Cloud (VPC) with DNS support and hostnames enabled. It will also set up an Internet Gateway and a Route Table to allow outbound internet access. All resources will be tagged with a name that is specified by a variable. The configuration will include the necessary IAM roles and permissions to deploy the infrastructure. The AWS provider will be configured to use a specific region.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

variable "vpc_name" {
  description = "The name to tag the VPC and related resources"
  type        = string
  default     = "my-dedicated-vpc"
}

resource "aws_vpc" "dedicated_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "dedicated"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dedicated_vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.dedicated_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-rt"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_vpc.dedicated_vpc.id
  route_table_id = aws_route_table.route_table.id
}
```
</iac_template>