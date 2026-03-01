provider "aws" {
  region = "us-east-1"
}

##########################
# S3 Bucket for Firehose #
##########################
resource "aws_s3_bucket" "firehose_s3_bucket" {
  bucket = "firehose-dynamic-partitioning-bucket-${random_id.bucket_id.hex}"
  acl    = "private"
  
  tags = {
    Name        = "firehose-s3-destination"
    Environment = "dev"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

#########################################
# CloudWatch Log Group and Log Stream   #
#########################################
resource "aws_cloudwatch_log_group" "firehose_log_group" {
  name              = "/aws/kinesisfirehose/firehose_stream"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "firehose_stream"
  log_group_name = aws_cloudwatch_log_group.firehose_log_group.name
}

##########################
# IAM Role for Firehose  #
##########################
data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firehose_role" {
  name               = "firehose_delivery_role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

data "aws_iam_policy_document" "firehose_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.firehose_s3_bucket.arn,
      "${aws_s3_bucket.firehose_s3_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.firehose_log_group.arn,
      "${aws_cloudwatch_log_group.firehose_log_group.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "firehose_policy" {
  name   = "firehose_delivery_policy"
  role   = aws_iam_role.firehose_role.id
  policy = data.aws_iam_policy_document.firehose_policy.json
}

##############################################
# Kinesis Firehose Delivery Stream with      #
# Extended S3 Destination & Dynamic Partitioning#
##############################################
resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  name        = "firehose_stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.firehose_s3_bucket.arn

    buffering_hints {
      size_in_mbs         = 5
      interval_in_seconds = 60
    }

    dynamic_partitioning_configuration {
      enabled                   = true
      retry_duration_in_seconds = 300
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.firehose_log_stream.name
    }
  }
}