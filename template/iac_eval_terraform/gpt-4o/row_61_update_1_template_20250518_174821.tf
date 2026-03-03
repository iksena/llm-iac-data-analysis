provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "firehose_backup" {
  bucket = "my-firehose-backup-bucket"
  acl    = "private"
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
  description = "Policy for Kinesis Firehose to access S3 and Elasticsearch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.firehose_backup.arn,
          "${aws_s3_bucket.firehose_backup.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "es:ESHttpPost",
          "es:ESHttpPut"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attach" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_policy.arn
}

resource "aws_elasticsearch_domain" "example" {
  domain_name = "my-es-domain"

  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
}

resource "aws_kinesis_firehose_delivery_stream" "firehose_to_es" {
  name        = "firehose-to-es"
  destination = "elasticsearch"

  elasticsearch_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    domain_arn          = aws_elasticsearch_domain.example.arn
    index_name          = "my-index"
    type_name           = "my-type"
    buffering_interval  = 300
    buffering_size      = 5
    retry_duration      = 300
    s3_backup_mode      = "AllDocuments"

    s3_configuration {
      role_arn           = aws_iam_role.firehose_role.arn
      bucket_arn         = aws_s3_bucket.firehose_backup.arn
      buffering_interval = 300
      buffering_size     = 5
      compression_format = "UNCOMPRESSED"
    }
  }
}