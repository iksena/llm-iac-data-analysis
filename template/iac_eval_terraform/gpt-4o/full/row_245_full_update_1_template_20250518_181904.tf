To set up a basic AWS Neptune cluster with a custom parameter group and an instance in that cluster, we will define a Terraform configuration that includes the following components:

1. **AWS Provider Configuration**: This will specify the AWS region where the resources will be deployed.

2. **VPC and Subnet**: A VPC and a subnet will be created to host the Neptune cluster and instance. The subnet will be used to control access to the Neptune instance.

3. **Security Group**: A security group will be created to allow inbound connections to the Neptune instance from the specified subnet.

4. **Neptune Parameter Groups**: Custom parameter groups for both the Neptune cluster and the instance will be defined to allow for specific configurations.

5. **Neptune Cluster**: The Neptune cluster will be created using the custom cluster parameter group.

6. **Neptune Instance**: An instance within the Neptune cluster will be created using its own custom parameter group.

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
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_security_group" "neptune_sg" {
  vpc_id = aws_vpc.neptune_vpc.id

  ingress {
    from_port   = 8182
    to_port     = 8182
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.neptune_subnet.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_neptune_parameter_group" "cluster_param_group" {
  name        = "custom-cluster-param-group"
  family      = "neptune1"
  description = "Custom parameter group for Neptune cluster"
}

resource "aws_neptune_parameter_group" "instance_param_group" {
  name        = "custom-instance-param-group"
  family      = "neptune1"
  description = "Custom parameter group for Neptune instance"
}

resource "aws_neptune_cluster" "neptune_cluster" {
  cluster_identifier      = "example-neptune-cluster"
  engine                  = "neptune"
  neptune_subnet_group_name = aws_neptune_subnet_group.neptune_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.neptune_sg.id]
  apply_immediately       = true
  neptune_cluster_parameter_group_name = aws_neptune_parameter_group.cluster_param_group.name
}

resource "aws_neptune_subnet_group" "neptune_subnet_group" {
  name       = "neptune-subnet-group"
  subnet_ids = [aws_subnet.neptune_subnet.id]
}

resource "aws_neptune_cluster_instance" "neptune_instance" {
  cluster_identifier       = aws_neptune_cluster.neptune_cluster.id
  instance_class           = "db.r5.large"
  apply_immediately        = true
  neptune_parameter_group_name = aws_neptune_parameter_group.instance_param_group.name
}
```
</iac_template>

This configuration sets up a basic AWS Neptune cluster with a custom parameter group and an instance in that cluster with its own custom parameter group. The security group ensures that only connections from the specified subnet are allowed to the Neptune instance.