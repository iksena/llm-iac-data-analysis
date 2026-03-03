provider "aws" {
  region = "us-west-2"
}

# Create a VPC for the infrastructure
resource "aws_vpc" "firehose_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "firehose-vpc"
  }
}

# Create a public subnet in the VPC
resource "aws_subnet" "firehose_subnet" {
  vpc_id                  = aws_vpc.firehose_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "firehose-subnet"
  }
}

# Create a security group for the Elasticsearch domain
resource "aws_security_group" "es_sg" {
  name        = "es-sg"
  description = "Security group for Elasticsearch domain"
  vpc_id      = aws_vpc.firehose_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust as needed for your security requirements.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "es-security-group"
  }
}

# Deploy Amazon Elasticsearch (OpenSearch) Domain inside the VPC:
resource "aws_elasticsearch_domain" "es_domain" {
  domain_name           = "example-es-domain"
  elasticsearch_version = "7.10"

  vpc_options {
    subnet_ids         = [aws_subnet.firehose_subnet.id]
    security_group_ids = [aws_security_group.es_sg.id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  cluster_config {
    instance_type = "t3.small.elasticsearch"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }

  tags = {
    Name = "example-es-domain"
  }
}

# Create an S3 bucket used by Firehose for backup of documents
resource "aws_s3_bucket" "firehose_backup" {
  bucket = "firehose-backup-bucket-unique-123456"  # Ensure this bucket name is globally unique.
  acl    = "private"

  tags = {
    Name = "firehose-backup-bucket"
  }
}

# IAM role for Kinesis Firehose
resource "aws_iam_role" "firehose_role" {
  name = "firehose_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM policy for the Firehose role to access ES, S3 and required EC2 actions.
resource "aws_iam_role_policy" "firehose_policy" {
  name   = "firehose_policy"
  role   = aws_iam_role.firehose_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "es:ESHttpPost",
          "es:ESHttpPut",
          "es:ESHttpDelete",
          "es:ESHttpHead"
        ]
        Effect   = "Allow"
        Resource = "${aws_elasticsearch_domain.es_domain.arn}/*"
      },
      {
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.firehose_backup.arn,
          "${aws_s3_bucket.firehose_backup.arn}/*"
        ]
      },
      {
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Create the Kinesis Firehose Delivery Stream with Elasticsearch destination and VPC configuration
resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  name        = "firehose-es-stream"
  destination = "elasticsearch"

  elasticsearch_configuration {
    domain_arn            = aws_elasticsearch_domain.es_domain.arn
    index_name            = "firehose-index"
    type_name             = "firehose-type"
    index_rotation_period = "OneDay"
    role_arn              = aws_iam_role.firehose_role.arn

    buffering_interval    = 300
    buffering_size        = 5

    retry_options {
      duration_in_seconds = 300
    }

    s3_backup_mode = "FailedDocumentsOnly"

    s3_configuration {
      bucket_arn = aws_s3_bucket.firehose_backup.arn
      role_arn   = aws_iam_role.firehose_role.arn
      buffering_interval = 300
      buffering_size     = 5
    }

    vpc_configuration {
      subnet_ids         = [aws_subnet.firehose_subnet.id]
      security_group_ids = [aws_security_group.es_sg.id]
    }
  }
}