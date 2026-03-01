To fulfill the business need, we will create a Redshift cluster with two nodes. We will also configure the concurrency scaling feature to limit it to 60 minutes. This setup will be deployed in the AWS cloud using Terraform. We will define the necessary IAM roles and policies to allow Redshift to function correctly. The configuration will include the AWS provider setup, Redshift cluster definition, and the concurrency scaling configuration.

<iac_template>

```hcl
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

resource "aws_iam_role_policy" "redshift_policy" {
  name = "redshift-policy"
  role = aws_iam_role.redshift_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect = "Allow"
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
  master_password    = "AdminPass123!"
  iam_roles          = [aws_iam_role.redshift_role.arn]

  # Concurrency scaling configuration
  enable_concurrency_scaling = true
  concurrency_scaling_config {
    max_concurrency_scaling_duration = 60
  }

  tags = {
    Name = "MyRedshiftCluster"
  }
}

output "redshift_endpoint" {
  value = aws_redshift_cluster.redshift_cluster.endpoint
}

output "redshift_role_arn" {
  value = aws_iam_role.redshift_role.arn
}
```

</iac_template>

This Terraform configuration sets up a Redshift cluster with two nodes, configures concurrency scaling to a maximum of 60 minutes, and includes the necessary IAM role and policy for Redshift to access AWS services like S3. The configuration is complete and deployable in the `us-west-2` region.