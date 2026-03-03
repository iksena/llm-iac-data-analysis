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