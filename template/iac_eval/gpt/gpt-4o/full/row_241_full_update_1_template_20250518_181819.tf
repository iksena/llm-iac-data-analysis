To set up a basic AWS Neptune cluster with a custom parameter group using Terraform, we will define a configuration that includes the following components:

1. **AWS Provider Configuration**: This will specify the AWS region where the resources will be deployed.

2. **VPC and Subnets**: Neptune requires a VPC with subnets to operate. We will create a new VPC and subnets for the Neptune cluster.

3. **Security Group**: A security group will be created to allow necessary traffic to the Neptune cluster.

4. **Neptune Parameter Group**: A custom parameter group will be created to configure specific settings for the Neptune cluster.

5. **Neptune Cluster**: The Neptune cluster will be created using the custom parameter group.

6. **Neptune Cluster Instance**: An instance will be created within the Neptune cluster.

Below is the Terraform HCL configuration to achieve this setup:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "neptune_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "neptune_subnet" {
  count             = 2
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.neptune_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "neptune_sg" {
  vpc_id = aws_vpc.neptune_vpc.id

  ingress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_neptune_parameter_group" "custom" {
  name        = "custom-neptune-parameter-group"
  family      = "neptune1"
  description = "Custom parameter group for Neptune"

  parameter {
    name  = "neptune_query_timeout"
    value = "120000"
  }
}

resource "aws_neptune_cluster" "example" {
  cluster_identifier      = "example-neptune-cluster"
  engine                  = "neptune"
  neptune_parameter_group_name = aws_neptune_parameter_group.custom.name
  vpc_security_group_ids  = [aws_security_group.neptune_sg.id]
}

resource "aws_neptune_cluster_instance" "example" {
  count               = 1
  cluster_identifier  = aws_neptune_cluster.example.id
  instance_class      = "db.r5.large"
  engine              = "neptune"
  availability_zone   = element(data.aws_availability_zones.available.names, 0)
  apply_immediately   = true
}
```
</iac_template>

This configuration sets up a basic AWS Neptune cluster with a custom parameter group, a VPC, subnets, and a security group to allow traffic on the necessary port. The Neptune cluster and instance are configured to use the custom parameter group.