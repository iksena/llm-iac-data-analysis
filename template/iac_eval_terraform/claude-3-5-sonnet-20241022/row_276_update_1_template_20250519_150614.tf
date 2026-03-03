provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-log-notification-bucket"
}

variable "email_address" {
  description = "Email address for SNS notifications"
  type        = string
  default     = "your-email@example.com"
}

# Create S3 Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.bucket_name
}

# Enable versioning
resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create SNS Topic
resource "aws_sns_topic" "log_notification" {
  name = "s3-log-notification"
}

# Create SNS Topic Subscription
resource "aws_sns_topic_subscription" "log_notification_subscription" {
  topic_arn = aws_sns_topic.log_notification.arn
  protocol  = "email"
  endpoint  = var.email_address
}

# Configure S3 Event Notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.log_bucket.id

  topic {
    topic_arn     = aws_sns_topic.log_notification.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}