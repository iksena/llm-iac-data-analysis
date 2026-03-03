Below is a description and the complete Terraform HCL configuration. This configuration creates two AWS S3 buckets: one bucket ("private_bucket") is set with a “private” ACL and will have its access logs sent to the second bucket; the other bucket ("logging_bucket") is configured with the “log-delivery-write” ACL to receive log files. The private bucket’s logging configuration specifies the target logging bucket and a log file prefix. Both buckets are fully defined, and all required dependencies, IAM requirements, and provider configuration are included.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# S3 bucket intended to receive logs (configured with log-delivery-write ACL)
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "my-unique-logging-bucket-terraform-example"
  acl    = "log-delivery-write"

  tags = {
    Name = "LoggingBucket"
  }
}

# S3 bucket with private ACL and logging enabled to send logs to the logging bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = "my-unique-private-bucket-terraform-example"
  acl    = "private"

  logging {
    target_bucket = aws_s3_bucket.logging_bucket.bucket
    target_prefix = "log-files/"
  }

  tags = {
    Name = "PrivateBucket"
  }
}
</iac_template>