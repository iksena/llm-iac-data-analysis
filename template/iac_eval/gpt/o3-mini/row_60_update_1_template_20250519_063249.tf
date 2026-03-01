provider "aws" {
  region = "us-east-1"
}

# Variables for Redshift credentials
variable "redshift_master_username" {
  description = "Redshift master username"
  type        = string
  default     = "masteruser"
}

variable "redshift_master_password" {
  description = "Redshift master password"
  type        = string
  default     = "MasterPass123"
}

# VPC and subnet for Redshift cluster
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Internet Gateway (optional but useful for public accessibility)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Redshift subnet group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "example-redshift-subnet-group"
  subnet_ids = [aws_subnet.main.id]
  description = "Subnet group for Redshift cluster"
}

# Security group for Redshift
resource "aws_security_group" "redshift_sg" {
  name        = "redshift-sg"
  description = "Allow access to Redshift"
  vpc_id      = aws_vpc.main.id

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

# Redshift cluster
resource "aws_redshift_cluster" "redshift" {
  cluster_identifier         = "example-redshift"
  database_name              = "dev"
  master_username            = var.redshift_master_username
  master_password            = var.redshift_master_password
  node_type                  = "dc2.large"
  cluster_type               = "single-node"
  publicly_accessible        = true

  cluster_subnet_group_name  = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.redshift_sg.id]

  # Let Terraform wait until the cluster is available.
  skip_final_snapshot = true
}

# Random ID for unique S3 bucket name
resource "random_id" "bucketid" {
  byte_length = 4
}

# S3 bucket for Firehose temporary staging
resource "aws_s3_bucket" "firehose_bucket" {
  bucket = "firehose-bucket-${random_id.bucketid.hex}"
  acl    = "private"

  tags = {
    Name = "FirehoseBucket"
  }
}

# IAM role for Firehose to access S3 and execute the Redshift COPY command.
resource "aws_iam_role" "firehose_role" {
  name = "firehose-delivery-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "firehose.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Inline policy for the Firehose role to allow S3 actions on the staging bucket.
resource "aws_iam_role_policy" "firehose_policy" {
  name = "firehose-policy"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.firehose_bucket.arn,
          "${aws_s3_bucket.firehose_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Kinesis Firehose Delivery Stream with a Redshift destination
resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name = "firehose_stream"
  delivery_stream_type = "DirectPut"

  redshift_configuration {
    # Build the JDBC URL using the Redshift cluster endpoint and database name.
    cluster_jdbcurl = "jdbc:redshift://${aws_redshift_cluster.redshift.endpoint}:5439/${aws_redshift_cluster.redshift.database_name}"

    # COPY command configuration
    copy_command {
      data_table_name = "test_table"
      copy_options    = "FORMAT AS JSON 'auto'"
    }

    username = var.redshift_master_username
    password = var.redshift_master_password

    # S3 configuration used as an intermediate staging area
    s3_configuration {
      bucket_arn        = aws_s3_bucket.firehose_bucket.arn
      role_arn          = aws_iam_role.firehose_role.arn
      buffering_interval = 300
      buffering_size     = 5
    }
  }

  # Ensure Firehose waits until the Redshift cluster is available.
  depends_on = [
    aws_redshift_cluster.redshift,
    aws_iam_role_policy.firehose_policy
  ]
}

# Required random provider
provider "random" {
  # default configuration
}