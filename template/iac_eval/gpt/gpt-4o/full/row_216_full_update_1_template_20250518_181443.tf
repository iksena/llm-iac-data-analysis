To create an Amazon Aurora PostgreSQL cluster using Terraform, we will define a configuration that includes the necessary resources such as the Aurora cluster itself, a subnet group for the cluster, and the appropriate security group. We will also configure the AWS provider to deploy the resources in a specified region. The configuration will include default values for variables to ensure the setup is deployable without additional input.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "aurora_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "aurora_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.aurora_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.aurora_vpc.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "aurora_sg" {
  vpc_id = aws_vpc.aurora_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
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

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-postgresql-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "13.4"
  master_username         = "aurora_master"
  master_password         = "aurora_password"
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  skip_final_snapshot     = true
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = aws_subnet.aurora_subnet[*].id
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 2
  identifier         = "aurora-postgresql-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.aurora_cluster.engine
}
```
</iac_template>

This configuration sets up an Aurora PostgreSQL cluster with two instances in a VPC with two subnets. The security group allows inbound traffic on port 5432, which is the default port for PostgreSQL. The cluster is configured to skip the final snapshot upon deletion for simplicity.