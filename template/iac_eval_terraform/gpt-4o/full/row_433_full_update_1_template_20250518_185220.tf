The Terraform program will create a Virtual Private Cloud (VPC) in the AWS us-east-2 region with a CIDR block of 10.0.0.0/16. Additionally, it will set up an Internet Gateway (IG) to allow internet access to resources within the VPC. Both the VPC and the Internet Gateway will be tagged with the names "vpc" and "ig" respectively. The configuration will include the necessary provider setup for AWS.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ig"
  }
}
```
</iac_template>