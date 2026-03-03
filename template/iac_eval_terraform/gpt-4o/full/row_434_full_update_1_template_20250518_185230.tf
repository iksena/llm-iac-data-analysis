The Terraform program will create a Virtual Private Cloud (VPC) and an Internet Gateway (IG) in the AWS us-east-2 region. The VPC will be assigned a CIDR block of 10.0.0.0/16, and both the VPC and the Internet Gateway will be tagged with the names "vpc" and "ig" respectively. This setup will allow resources within the VPC to communicate with the internet through the Internet Gateway.

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