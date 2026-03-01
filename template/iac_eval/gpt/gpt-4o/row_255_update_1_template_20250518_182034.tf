provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_redshift_subnet_group" "example" {
  name       = "example-redshift-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}

resource "aws_iam_role" "redshift_role" {
  name = "redshift-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_policy_attachment" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_redshift_cluster" "example" {
  cluster_identifier = "example-cluster"
  node_type          = "dc2.large"
  master_username    = "adminuser"
  master_password    = "Admin12345"
  cluster_type       = "single-node"
  iam_roles          = [aws_iam_role.redshift_role.arn]
  subnet_group_name  = aws_redshift_subnet_group.example.name
}

resource "aws_redshift_endpoint_access" "example" {
  cluster_identifier = aws_redshift_cluster.example.cluster_identifier
  endpoint_name      = "example-endpoint"
  subnet_group_name  = aws_redshift_subnet_group.example.name
  vpc_security_group_ids = []
}