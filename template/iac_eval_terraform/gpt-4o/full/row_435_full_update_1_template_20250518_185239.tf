The Terraform program will create a Virtual Private Cloud (VPC) in the AWS us-east-2 region with a CIDR block of 10.0.0.0/16. Additionally, it will set up an Internet Gateway to allow resources within the VPC to access the internet. The configuration will include the necessary provider setup and resource definitions to ensure the VPC and Internet Gateway are properly created and associated.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-2"
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