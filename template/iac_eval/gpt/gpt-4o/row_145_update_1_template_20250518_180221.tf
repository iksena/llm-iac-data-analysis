provider "aws" {
  region = "us-east-1"
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

resource "aws_redshift_cluster" "primary" {
  cluster_identifier = "primary-redshift-cluster"
  node_type          = "dc2.large"
  number_of_nodes    = 2
  master_username    = "adminuser"
  master_password    = "Admin12345"
  iam_roles          = [aws_iam_role.redshift_role.arn]

  snapshot_copy {
    destination_region = "us-east-2"
    grant_name         = aws_redshift_snapshot_copy_grant.copy_grant.name
  }
}

resource "aws_redshift_snapshot_copy_grant" "copy_grant" {
  snapshot_copy_grant_name = "redshift-snapshot-copy-grant"
  kms_key_id               = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"
}