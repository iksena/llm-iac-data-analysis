To create a RedShift cluster with a single node using Terraform, we will define a configuration that includes the AWS provider, an IAM role for RedShift, and the RedShift cluster itself. The configuration will specify the necessary parameters for the RedShift cluster, such as the node type, database name, master username, and password. We will also ensure that the cluster is created in a specific AWS region.

Here is the Terraform HCL program to achieve this:

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
  master_username    = "masteruser"
  master_password    = "MasterUserPassword1"
  cluster_type       = "single-node"
  database_name      = "exampledb"
  iam_roles          = [aws_iam_role.redshift_role.arn]

  tags = {
    Name = "example-cluster"
  }
}
```
</iac_template>

This configuration sets up a RedShift cluster in the `us-west-2` region with a single node of type `dc2.large`. It also creates an IAM role with Amazon S3 read-only access, which is attached to the RedShift cluster to allow it to read data from S3. The cluster is identified by `example-cluster`, and the database is named `exampledb`. The master username and password are set to `masteruser` and `MasterUserPassword1`, respectively.