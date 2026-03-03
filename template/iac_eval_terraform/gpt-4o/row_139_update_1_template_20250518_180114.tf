provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "redshift_role" {
  name = "redshift-cluster-role"

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
  master_username    = "masteruser"
  master_password    = "MasterUserPassword1"
  cluster_type       = "single-node"
  database_name      = "exampledb"
  iam_roles          = [aws_iam_role.redshift_role.arn]

  tags = {
    Name = "example-cluster"
  }
}