provider "aws" {
  region = "us-east-1"
}

# S3 Bucket to store Firehose delivered objects.
resource "aws_s3_bucket" "firehose_bucket" {
  bucket        = "firehose-destination-bucket-123456"  # Replace with a unique bucket name as needed.
  acl           = "private"
  force_destroy = true
}

# IAM Role for Kinesis Firehose to assume and perform S3 and CloudWatch Logs operations.
resource "aws_iam_role" "firehose_delivery_role" {
  name = "firehose_delivery_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "firehose.amazonaws.com"
      }
    }]
  })
}

# IAM Policy providing Firehose necessary permissions to interact with S3 and CloudWatch Logs.
resource "aws_iam_policy" "firehose_delivery_policy" {
  name   = "firehose_delivery_policy"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        Resource = [
          aws_s3_bucket.firehose_bucket.arn,
          "${aws_s3_bucket.firehose_bucket.arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = [
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the Firehose delivery IAM role.
resource "aws_iam_role_policy_attachment" "firehose_policy_attachment" {
  role       = aws_iam_role.firehose_delivery_role.name
  policy_arn = aws_iam_policy.firehose_delivery_policy.arn
}

# Kinesis Firehose Delivery Stream with an Extended S3 Destination.
resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  name        = "firehose-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    bucket_arn = aws_s3_bucket.firehose_bucket.arn
    role_arn   = aws_iam_role.firehose_delivery_role.arn

    # Buffer settings
    buffering_interval = 300
    buffering_size     = 5

    # Compression configuration (set to UNCOMPRESSED; adjust as needed)
    compression_format = "UNCOMPRESSED"
  }
}