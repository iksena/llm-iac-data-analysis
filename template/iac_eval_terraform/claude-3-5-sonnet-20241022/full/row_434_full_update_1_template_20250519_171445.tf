I'll help you create a Terraform configuration that sets up a VPC with a CIDR block and an Internet Gateway in the AWS us-east-2 region.

Description:
This Terraform configuration will:
1. Set up the AWS provider in the us-east-2 region
2. Create a VPC with a CIDR block of 10.0.0.0/16
3. Create an Internet Gateway
4. Attach the Internet Gateway to the VPC
5. Apply appropriate tags to both resources

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-2"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ig"
  }
}
</iac_template>

This configuration will create:
1. A VPC with CIDR block 10.0.0.0/16, which provides 65,536 IP addresses
2. An Internet Gateway that's attached to the VPC
3. Both resources are properly tagged as requested
4. DNS support and DNS hostnames are enabled in the VPC for better functionality

The configuration is complete and deployable. You can run `terraform init`, `terraform plan`, and `terraform apply` to deploy this infrastructure in your AWS account.