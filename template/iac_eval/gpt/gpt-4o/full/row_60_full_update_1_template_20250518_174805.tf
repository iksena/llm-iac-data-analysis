To fulfill the business need, we will create a Terraform configuration that sets up an AWS Kinesis Firehose Delivery Stream with an Amazon Redshift cluster as the destination. The configuration will include the necessary IAM roles and policies to allow Kinesis Firehose to write data to the Redshift cluster. We will also set up the Redshift cluster and the associated resources such as a VPC, subnets, and security groups.

The configuration will include:
1. An AWS provider configuration.
2. A VPC with public and private subnets.
3. An IAM role and policy for Kinesis Firehose to access Redshift.
4. A Redshift cluster.
5. A Kinesis Firehose Delivery Stream configured to deliver data to the Redshift cluster.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_security_group" "redshift_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_policy" {
  name        = "firehose_delivery_policy"
  description = "Policy for Kinesis Firehose to access Redshift"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "redshift:DescribeCluster",
          "redshift:DescribeClusters",
          "redshift:GetClusterCredentials"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "kms:Decrypt"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attach" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_policy.arn
}

resource "aws_redshift_cluster" "main" {
  cluster_identifier = "redshift-cluster-1"
  node_type          = "dc2.large"
  master_username    = "adminuser"
  master_password    = "Admin12345"
  cluster_type       = "single-node"
  vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  publicly_accessible    = true
}

resource "aws_kinesis_firehose_delivery_stream" "redshift_stream" {
  name        = "firehose-to-redshift"
  destination = "redshift"

  redshift_configuration {
    cluster_jdbcurl = "jdbc:redshift://${aws_redshift_cluster.main.endpoint}:5439/dev"
    username        = aws_redshift_cluster.main.master_username
    password        = aws_redshift_cluster.main.master_password
    role_arn        = aws_iam_role.firehose_role.arn
    data_table_name = "my_table"
    copy_options    = "JSON 'auto'"
  }
}
```
</iac_template>