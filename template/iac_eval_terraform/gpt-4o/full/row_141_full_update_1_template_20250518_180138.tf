To fulfill the business need, we will create a Terraform configuration that sets up a 2-node Amazon Redshift cluster. Additionally, we will create an Amazon Redshift endpoint authorization for an external AWS account with the ID 012345678910. The configuration will include the necessary IAM roles and policies to allow the Redshift cluster to function correctly. We will use the AWS provider and specify a region for deployment.

The Terraform configuration will include:
1. AWS provider configuration.
2. An IAM role for Redshift with the necessary policies.
3. A Redshift cluster with 2 nodes.
4. An endpoint authorization for the specified AWS account.

Here is the Terraform HCL configuration:

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

resource "aws_iam_role_policy_attachment" "redshift_policy_attachment" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_redshift_cluster" "example" {
  cluster_identifier = "example-cluster"
  node_type          = "dc2.large"
  number_of_nodes    = 2
  master_username    = "adminuser"
  master_password    = "AdminPass123"
  iam_roles          = [aws_iam_role.redshift_role.arn]

  tags = {
    Name = "example-cluster"
  }
}

resource "aws_redshift_endpoint_authorization" "example" {
  account      = "012345678910"
  cluster_identifier = aws_redshift_cluster.example.cluster_identifier
}
```
</iac_template>

This configuration will create a Redshift cluster with two nodes and authorize the specified AWS account to access the cluster's endpoint. The IAM role attached to the Redshift cluster allows it to read from S3, which is a common requirement for Redshift clusters.