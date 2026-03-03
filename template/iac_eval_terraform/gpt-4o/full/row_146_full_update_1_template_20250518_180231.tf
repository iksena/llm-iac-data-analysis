To fulfill the business need, we will create an AWS IAM role with the necessary permissions to allow Redshift to access AWS services. We will then create an Amazon Redshift cluster and associate the IAM role with it. The Redshift cluster will be configured with a default node type and number of nodes. The IAM role will have a policy that allows Redshift to access Amazon S3, which is commonly used for data loading and unloading.

Below is the Terraform HCL configuration that accomplishes this:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "redshift_role" {
  name = "RedshiftIAMRole"

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
  name = "RedshiftS3AccessPolicy"
  role = aws_iam_role.redshift_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
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
  master_password    = "AdminPass123"
  iam_roles          = [aws_iam_role.redshift_role.arn]

  # Additional configuration can be added here as needed
}
```
</iac_template>

This configuration sets up an IAM role with a policy that allows access to S3, creates a Redshift cluster with two nodes of type `dc2.large`, and associates the IAM role with the Redshift cluster. The master username and password are set to default values, which should be changed to meet security requirements.