provider "aws" {
  region = "us-east-1"
}

# Create SNS Topic
resource "aws_sns_topic" "s3_event_notification" {
  name = "s3-event-notification-topic"
}

# Create IAM Policy Document for SNS Topic
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect = "Allow"
    
    principals {
      type = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["SNS:Publish"]
    
    resources = [aws_sns_topic.s3_event_notification.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.notification_bucket.arn]
    }
  }
}

# Attach Policy to SNS Topic
resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.s3_event_notification.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

# Create S3 Bucket
resource "aws_s3_bucket" "notification_bucket" {
  bucket = "your-bucket-name"
}

# Enable versioning for S3 bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.notification_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Add bucket notification configuration
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.notification_bucket.id

  topic {
    topic_arn     = aws_sns_topic.s3_event_notification.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }

  depends_on = [aws_sns_topic_policy.default]
}