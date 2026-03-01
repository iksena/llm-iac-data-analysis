provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "firehose-vpc"
  }
}

# Create two public subnets (in different AZs)
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "firehose-subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "firehose-subnet-2"
  }
}

# Create a security group for OpenSearch that allows communication from the VPC
resource "aws_security_group" "opensearch_sg" {
  name        = "opensearch-sg"
  description = "Allow OpenSearch communication"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "opensearch-sg"
  }
}

# Create an OpenSearch domain with VPC options so that it is deployed within the VPC
resource "aws_opensearch_domain" "example" {
  domain_name           = "example-opensearch"
  engine_version        = "OpenSearch_1.0"
  cluster_config {
    instance_type = "t3.small.search"
  }
  vpc_options {
    subnet_ids         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_group_ids = [aws_security_group.opensearch_sg.id]
  }
  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }
  
  tags = {
    Name = "example-opensearch"
  }
}

# Create an S3 bucket for Firehose backups (for failed documents)
resource "aws_s3_bucket" "firehose_backup" {
  bucket = "firehose-backup-${random_id.bucket_id.hex}"
  acl    = "private"

  tags = {
    Name = "firehose-backup"
  }
}

# Create a random id to ensure unique bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}

# Create an IAM role that Kinesis Firehose will assume.
resource "aws_iam_role" "firehose_role" {
  name = "firehose-delivery-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "firehose.amazonaws.com"
      }
    }]
  })
}

# Attach inline policy to the IAM role to allow access to OpenSearch and S3
resource "aws_iam_role_policy" "firehose_policy" {
  name   = "firehose-delivery-policy"
  role   = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "es:ESHttpPost",
          "es:ESHttpPut",
          "es:ESHttpHead"
        ]
        Effect   = "Allow"
        Resource = "${aws_opensearch_domain.example.arn}/*"
      },
      {
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.firehose_backup.arn
      },
      {
        Action = [
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.firehose_backup.arn}/*"
      }
    ]
  })
}

# Create the Kinesis Firehose Delivery Stream with OpenSearch Destination.
resource "aws_kinesis_firehose_delivery_stream" "example" {
  name        = "example-firehose-stream"
  destination = "opensearch"

  opensearch_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    domain_arn = aws_opensearch_domain.example.arn
    index_name = "my-index"
    type_name  = "my-type"
    # S3 backup configuration for failed documents
    s3_backup_mode = "FailedDocumentsOnly"
    s3_configuration {
      role_arn   = aws_iam_role.firehose_role.arn
      bucket_arn = aws_s3_bucket.firehose_backup.arn
      prefix     = "firehose-backup/"
    }
    # VPC configuration for accessing the OpenSearch domain inside the VPC
    vpc_configuration {
      subnet_ids         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
      security_group_ids = [aws_security_group.opensearch_sg.id]
    }
  }
}

# Required random provider for random_id resource
provider "random" {
  # no configuration needed
}