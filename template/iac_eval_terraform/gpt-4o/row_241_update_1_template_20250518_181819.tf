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