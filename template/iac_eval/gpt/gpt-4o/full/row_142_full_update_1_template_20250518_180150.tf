To fulfill the business need, we will create a Terraform configuration that sets up a single-node Amazon Redshift cluster. Additionally, we will configure an Amazon Redshift snapshot schedule to automatically create a snapshot of the cluster every 12 hours. We will use the AWS provider to manage the resources, and we will define the necessary IAM roles and policies to allow Redshift to create snapshots. The configuration will be deployed in the `us-west-2` region.

<iac_template>

```hcl
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
```

</iac_template>

This configuration will create a single-node Redshift cluster with a snapshot schedule that triggers every 12 hours. The IAM role and policy are set up to allow Redshift to interact with S3, which is necessary for snapshot operations.