To fulfill the business need, we will create a Terraform configuration that sets up an AWS Kinesis Firehose Delivery Stream with an extended S3 destination. This configuration will include the necessary IAM roles and policies to allow the Firehose to write to the S3 bucket. We will also configure the S3 bucket to store the data delivered by the Firehose. The configuration will be set up in the `us-west-2` region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "firehose_bucket" {
  bucket = "my-firehose-extended-s3-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
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
  description = "Policy for Kinesis Firehose to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "${aws_s3_bucket.firehose_bucket.arn}",
          "${aws_s3_bucket.firehose_bucket.arn}/*"
        ]
      },
      {
        Action = "logs:PutLogEvents"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attachment" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_policy.arn
}

resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name        = "my-firehose-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.firehose_bucket.arn

    buffering_hints {
      interval_in_seconds = 300
      size_in_mbs         = 5
    }

    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/my-firehose-stream"
      log_stream_name = "S3Delivery"
    }
  }
}
```
</iac_template>