provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "dax_role" {
  name = "dax-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dax.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "dax_policy" {
  name = "dax-cluster-policy"
  role = aws_iam_role.dax_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:*",
          "cloudwatch:*",
          "logs:*",
          "sns:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_dax_cluster" "example" {
  cluster_name           = "example-dax-cluster"
  node_type              = "dax.r4.large"
  replication_factor     = 1
  iam_role_arn           = aws_iam_role.dax_role.arn
  parameter_group_name   = "default.dax1.0"
  subnet_group_name      = aws_dax_subnet_group.example.name

  tags = {
    Name = "example-dax-cluster"
  }
}

resource "aws_dax_subnet_group" "example" {
  name       = "example-dax-subnet-group"
  subnet_ids = aws_subnet.example.*.id
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  count             = 2
  vpc_id            = aws_vpc.example.id
  cidr_block        = cidrsubnet(aws_vpc.example.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}