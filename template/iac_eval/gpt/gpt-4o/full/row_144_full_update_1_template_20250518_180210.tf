To set up a highly available Amazon Redshift cluster across multiple availability zones in the `us-east-1` region, we will create a Redshift cluster with multiple nodes. We will use the `aws_redshift_cluster` resource to define the cluster and specify the availability zones for the subnets in a subnet group. The cluster will be deployed in the `us-east-1` region, and we will ensure that it spans across the specified availability zones for high availability. We will also create an IAM role to allow Redshift to access other AWS services if needed.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "redshift_role" {
  name = "redshift-iam-role"

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

resource "aws_vpc" "redshift_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "redshift_subnet_a" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "redshift_subnet_b" {
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.redshift_subnet_a.id, aws_subnet.redshift_subnet_b.id]
}

resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier = "my-redshift-cluster"
  node_type          = "dc2.large"
  master_username    = "adminuser"
  master_password    = "AdminPass123"
  cluster_type       = "multi-node"
  number_of_nodes    = 2
  iam_roles          = [aws_iam_role.redshift_role.arn]
  subnet_group_name  = aws_redshift_subnet_group.redshift_subnet_group.name
}
```
</iac_template>

This configuration sets up a VPC with two subnets in different availability zones, creates a Redshift subnet group, and deploys a multi-node Redshift cluster with IAM role access to S3. The cluster is configured to be highly available across the specified availability zones.