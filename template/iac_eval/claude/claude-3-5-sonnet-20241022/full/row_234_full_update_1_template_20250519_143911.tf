I'll help you create a Terraform configuration that sets up an AWS VPC with an attached Internet Gateway. This is a fundamental networking setup in AWS that allows resources within the VPC to communicate with the internet.

The configuration will:
1. Create a VPC with a specified CIDR block
2. Create an Internet Gateway
3. Attach the Internet Gateway to the VPC
4. Use AWS provider in us-east-1 region

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
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
</iac_template>

This Terraform configuration will:
1. Set up the AWS provider in the us-east-1 region
2. Create a VPC with CIDR block 10.0.0.0/16 and enable DNS support
3. Create an Internet Gateway and attach it to the VPC automatically
4. Add appropriate tags to both resources for better identification

The VPC will have a CIDR block of 10.0.0.0/16, which provides 65,536 IP addresses. The Internet Gateway will be automatically attached to the VPC using the vpc_id attribute reference. Both resources are tagged for better organization and management.

This configuration provides the basic networking infrastructure needed for a cloud deployment in AWS. You can deploy this by running:
1. terraform init
2. terraform plan
3. terraform apply