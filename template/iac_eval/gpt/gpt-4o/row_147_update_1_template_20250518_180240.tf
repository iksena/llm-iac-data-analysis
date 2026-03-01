provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "redshift_role" {
  name = "RedshiftClusterRole"

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

resource "aws_iam_role_policy" "redshift_policy" {
  name   = "RedshiftPolicy"
  role   = aws_iam_role.redshift_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier = "my-redshift-cluster"
  node_type          = "dc2.large"
  number_of_nodes    = 2
  master_username    = "adminuser"
  master_password    = "AdminPass123"
  iam_roles          = [aws_iam_role.redshift_role.arn]

  tags = {
    Name = "MyRedshiftCluster"
  }
}

resource "aws_redshift_scheduled_action" "redshift_policy" {
  scheduled_action_name = "MyRedshiftPolicy"
  enable                = true
  iam_role              = aws_iam_role.redshift_role.arn
  schedule              = "rate(1 day)"
  target_action {
    pause_cluster {
      cluster_identifier = aws_redshift_cluster.redshift_cluster.cluster_identifier
    }
  }
}