To fulfill the business need, we will create an AWS Virtual Private Cloud (VPC) and attach an Internet Gateway to it. This setup will allow resources within the VPC to communicate with the internet. The Terraform configuration will include the AWS provider setup, the VPC resource, and the Internet Gateway resource. We will also ensure that the Internet Gateway is properly attached to the VPC.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}
```
</iac_template>