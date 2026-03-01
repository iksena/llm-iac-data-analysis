To create an AWS Neptune cluster, we need to set up the necessary networking infrastructure, which includes creating two subnets and grouping them into a subnet group. AWS Neptune is a managed graph database service, and it requires a VPC with subnets to operate. In this Terraform configuration, we will define a VPC, create two subnets within that VPC, and then create a Neptune subnet group that includes these subnets. We will also configure the AWS provider to deploy resources in a specific region.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "neptune_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "neptune-vpc"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "neptune-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "neptune-subnet-2"
  }
}

resource "aws_neptune_subnet_group" "neptune_subnet_group" {
  name       = "neptune-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "neptune-subnet-group"
  }
}
```

</iac_template>

This configuration sets up a VPC with two subnets in different availability zones and groups them into a Neptune subnet group, which can be used to deploy an AWS Neptune cluster. The AWS provider is configured to use the `us-west-2` region.