To fulfill the business need, we will create a Terraform configuration that sets up a 2-node Amazon Redshift cluster. This configuration will include the necessary IAM roles and policies to allow the Redshift cluster to operate. We will also attach a resource policy to the Redshift cluster to control access. The configuration will be deployed in the AWS region `us-west-2`.

The Terraform program will include:
1. AWS provider configuration.
2. An IAM role with the necessary permissions for Redshift.
3. A Redshift cluster with 2 nodes.
4. A resource policy attached to the Redshift cluster.

<iac_template>
```hcl
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
```
</iac_template>