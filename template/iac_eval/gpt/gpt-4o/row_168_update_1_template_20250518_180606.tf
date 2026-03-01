provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "dax_service_role" {
  name = "DAXServiceRole"

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
  name   = "DAXPolicy"
  role   = aws_iam_role.dax_service_role.id
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
  cluster_name      = "example-dax-cluster"
  node_type         = "dax.r4.large"
  replication_factor = 1
  iam_role_arn      = aws_iam_role.dax_service_role.arn

  parameter_group_name = "default.dax1.0"
}