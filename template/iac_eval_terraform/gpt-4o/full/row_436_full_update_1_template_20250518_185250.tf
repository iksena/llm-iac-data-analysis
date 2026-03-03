The Terraform program will create a Virtual Private Cloud (VPC) in the AWS us-east-2 region with a specified CIDR block. Additionally, it will set up an Internet Gateway (IG) to allow internet access for resources within the VPC. Both the VPC and the Internet Gateway will be tagged with the names "vpc" and "ig" respectively. The configuration will include the necessary provider setup for AWS.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ig"
  }
}
```
</iac_template>