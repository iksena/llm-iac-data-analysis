provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "msk_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "msk_subnet" {
  count             = 2
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.msk_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

resource "aws_msk_cluster" "serverless_msk" {
  cluster_name = "serverless-msk-cluster"
  kafka_version = "2.8.1"

  serverless {
    vpc_configs {
      subnet_ids = aws_subnet.msk_subnet[*].id
    }
  }

  dynamic "configuration_info" {
    for_each = []
    content {
      arn      = ""
      revision = 0
    }
  }
}

resource "aws_iam_role" "msk_role" {
  name = "MSKServerlessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kafka.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "msk_policy" {
  name        = "MSKServerlessPolicy"
  description = "Policy for MSK Serverless Cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "msk_policy_attachment" {
  role       = aws_iam_role.msk_role.name
  policy_arn = aws_iam_policy.msk_policy.arn
}