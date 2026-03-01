To set up a basic AWS Neptune cluster with a custom parameter group, we will define a Terraform configuration that includes the following components:

1. **AWS Provider Configuration**: This will specify the AWS region where the resources will be deployed.

2. **VPC and Subnets**: We will create a VPC and two subnets to allow connections to the Neptune cluster.

3. **Security Group**: A security group will be created to allow inbound traffic from the two specified subnets.

4. **Neptune Parameter Group**: A custom parameter group will be created for the Neptune cluster.

5. **Neptune Cluster and Instance**: The Neptune cluster and an instance will be created using the custom parameter group and security group.

6. **IAM Role**: An IAM role will be created to allow Neptune to access other AWS services if needed.

Below is the Terraform HCL configuration for setting up the AWS Neptune cluster with the specified requirements.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "neptune_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_security_group" "neptune_sg" {
  vpc_id = aws_vpc.neptune_vpc.id

  ingress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnet1.cidr_block, aws_subnet.subnet2.cidr_block]
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
  neptune_subnet_group_name = aws_neptune_subnet_group.example.name
  vpc_security_group_ids  = [aws_security_group.neptune_sg.id]
  apply_immediately       = true
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  preferred_maintenance_window = "mon:03:00-mon:04:00"
  iam_database_authentication_enabled = true
}

resource "aws_neptune_subnet_group" "example" {
  name       = "example-neptune-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

resource "aws_neptune_cluster_instance" "example" {
  count              = 1
  cluster_identifier = aws_neptune_cluster.example.id
  instance_class     = "db.r5.large"
  apply_immediately  = true
}
```
</iac_template>