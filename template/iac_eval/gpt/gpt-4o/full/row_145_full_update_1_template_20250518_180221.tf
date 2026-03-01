To fulfill the business need, we will set up a 2-node Amazon Redshift cluster in the `us-east-1` region and configure a snapshot copy to replicate the data to the `us-east-2` region. This setup will involve creating the Redshift cluster with the necessary IAM roles and policies to allow for cross-region snapshot replication. The configuration will include the Redshift cluster, IAM roles, and the snapshot copy grant.

<iac_template>

```hcl
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
```

</iac_template>

This configuration sets up a Redshift cluster in `us-east-1` with a snapshot copy to `us-east-2`. It includes an IAM role with S3 read-only access, which is often necessary for Redshift operations. The snapshot copy grant is configured to allow the replication of snapshots to the secondary region. Make sure to replace `"arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"` with your actual KMS key ARN.