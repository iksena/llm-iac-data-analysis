Below is a description of the Terraform program followed by the complete HCL code.

Description:
• This Terraform configuration sets up an Amazon Kinesis Data Firehose Delivery Stream whose destination is an HTTP endpoint (for example, a New Relic ingest URL). In case records cannot be delivered to the HTTP endpoint, the stream will automatically back up those records in an Amazon S3 bucket.
• An IAM role is created for Kinesis Firehose with a trust policy allowing firehose.amazonaws.com to assume it. An inline policy is attached to allow the necessary S3 actions on the backup bucket.
• An S3 bucket is provisioned to serve as the backup destination.
• The delivery stream resource uses the new HTTP endpoint configuration block. In that block a URL (supplied via a variable with a default value) is given along with buffering hints and an example request configuration (adding a common header). It also defines an S3 backup configuration section (with sample buffering and compression settings) along with a backup mode.
• Finally, the AWS provider is configured with a default region.

Below is the complete Terraform HCL program:

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to deploy to."
  type        = string
  default     = "us-east-1"
}

variable "http_endpoint_url" {
  description = "HTTP endpoint URL where Firehose will send data (e.g., a New Relic ingest URL)."
  type        = string
  default     = "https://insights-collector.newrelic.com/v1/accounts/12345/events"
}

# Create an S3 bucket to serve as backup destination for failed HTTP deliveries.
resource "aws_s3_bucket" "firehose_backup" {
  bucket = "firehose-backup-${random_id.bucket_suffix.hex}"
  acl    = "private"

  tags = {
    Name = "FirehoseBackup"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create an IAM role for Kinesis Firehose
resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = ""
        Effect    = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach inline policy to the IAM role to enable access to the backup S3 bucket.
resource "aws_iam_role_policy" "firehose_policy" {
  name   = "firehose_policy"
  role   = aws_iam_role.firehose_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.firehose_backup.arn,
          "${aws_s3_bucket.firehose_backup.arn}/*"
        ]
      }
    ]
  })
}

# Create the Kinesis Data Firehose Delivery Stream with HTTP endpoint destination.
resource "aws_kinesis_firehose_delivery_stream" "http_firehose" {
  name       = "new-relic-firehose-stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    # A friendly name for the HTTP endpoint.
    name = "newrelic-http-endpoint"
    url  = var.http_endpoint_url

    # Buffer records up to these values before sending to the HTTP endpoint.
    buffering_hints {
      interval_in_seconds = 300
      size_in_mbs         = 3
    }

    # Example request configuration adding a common attribute (like setting content type).
    request_configuration {
      common_attributes {
        attribute_name  = "Content-Type"
        attribute_value = "application/json"
      }
    }

    # Configure backup options in case records cannot be delivered successfully.
    s3_backup_mode = "FailedDataOnly"

    s3_configuration {
      role_arn   = aws_iam_role.firehose_role.arn
      bucket_arn = aws_s3_bucket.firehose_backup.arn

      buffering_hints {
        interval_in_seconds = 300
        size_in_mbs         = 5
      }

      compression_format = "GZIP"
    }
  }
}

# Generate a random suffix for unique bucket naming.
resource "random_id" "id" {
  byte_length = 4
}
</iac_template>