provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "redshift_role" {
  name = "RedshiftSnapshotRole"

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
  name = "RedshiftSnapshotPolicy"
  role = aws_iam_role.redshift_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_redshift_cluster" "example" {
  cluster_identifier = "example-cluster"
  node_type          = "dc2.large"
  master_username    = "masteruser"
  master_password    = "MasterUserPassword1"
  cluster_type       = "single-node"
  iam_roles          = [aws_iam_role.redshift_role.arn]

  tags = {
    Name = "example-cluster"
  }
}

resource "aws_redshift_snapshot_schedule" "example" {
  identifier = "example-snapshot-schedule"
  definitions = [
    "rate(12 hours)"
  ]
}

resource "aws_redshift_snapshot_schedule_association" "example" {
  cluster_identifier         = aws_redshift_cluster.example.id
  schedule_identifier        = aws_redshift_snapshot_schedule.example.id
}