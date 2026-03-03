Below is an explanation of the Terraform program followed by the complete HCL configuration. This configuration creates an AWS OpenSearch domain, an S3 bucket (with a random suffix) that serves as the backup destination for failed Firehose documents, an IAM role that Firehose uses with an inline policy granting access to the OpenSearch domain and backup bucket, and finally a Kinesis Firehose Delivery Stream with an OpenSearch destination. All necessary resources are declared and configured with default values and a valid AWS provider configuration.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Generate a random id for unique S3 bucket naming
resource "random_id" "bucket" {
  byte_length = 4
}

# S3 bucket to serve as backup for failed documents from Firehose
resource "aws_s3_bucket" "firehose_backup" {
  bucket = "firehose-backup-${random_id.bucket.hex}"
  acl    = "private"
}

# Create an OpenSearch Domain (formerly ElasticSearch Domain)
resource "aws_opensearch_domain" "example" {
  domain_name    = "example-domain"
  engine_version = "OpenSearch_1.0"

  cluster_config {
    instance_type = "t3.small.search"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }
}

# IAM Role for Firehose to assume
resource "aws_iam_role" "firehose_delivery_role" {
  name = "firehose_delivery_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach inline policy to the IAM Role which gives Firehose the required permissions to interact with OpenSearch domain and S3 bucket.
resource "aws_iam_role_policy" "firehose_policy" {
  name   = "firehose_policy"
  role   = aws_iam_role.firehose_delivery_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "es:ESHttpPost",
        "es:ESHttpPut",
        "es:ESHttpGet"
      ],
      "Effect": "Allow",
      "Resource": "${aws_opensearch_domain.example.arn}/*"
    },
    {
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.firehose_backup.arn}",
        "${aws_s3_bucket.firehose_backup.arn}/*"
      ]
    }
  ]
}
EOF
}

# Kinesis Firehose Delivery Stream with an OpenSearch destination.
resource "aws_kinesis_firehose_delivery_stream" "firehose_to_opensearch" {
  name = "firehose-to-opensearch"

  opensearch_destination_configuration {
    domain_arn         = aws_opensearch_domain.example.arn
    index_name         = "firehose-index"
    type_name          = "doc"
    role_arn           = aws_iam_role.firehose_delivery_role.arn
    s3_backup_mode     = "FailedDocumentsOnly"
    buffer_size        = 1       # Buffer size in MB before delivery
    buffer_interval    = 300     # Buffer interval in seconds before delivery
    retry_duration     = 300     # Retry duration in seconds in case of failures

    s3_configuration {
      bucket_arn         = aws_s3_bucket.firehose_backup.arn
      role_arn           = aws_iam_role.firehose_delivery_role.arn
      buffer_size        = 5       # Buffer size for S3 backup in MB
      buffer_interval    = 300     # Buffer interval for S3 backup in seconds
      compression_format = "UNCOMPRESSED"
    }
  }
}
</iac_template>