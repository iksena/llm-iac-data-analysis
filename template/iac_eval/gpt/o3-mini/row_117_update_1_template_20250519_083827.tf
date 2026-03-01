provider "aws" {
  region = "us-east-1"
}

# Create the SNS topic for S3 event notifications.
resource "aws_sns_topic" "s3_event_notification_topic" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.sns_policy.json
}

# IAM policy document for SNS topic to allow S3 to publish notifications.
data "aws_iam_policy_document" "sns_policy" {
  statement {
    sid    = "AllowS3Publish"
    actions = [
      "SNS:Publish"
    ]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    resources = [
      aws_sns_topic.s3_event_notification_topic.arn
    ]
    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:s3:::your-bucket-name"]
    }
  }
}

# Create the S3 bucket.
resource "aws_s3_bucket" "your_bucket" {
  bucket = "your-bucket-name"
}

# Configure S3 bucket notifications to send events to the SNS topic.
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.your_bucket.id

  topic {
    topic_arn = aws_sns_topic.s3_event_notification_topic.arn
    events    = ["s3:ObjectCreated:*"]

    filter {
      key {
        filter_rules {
          name  = "suffix"
          value = ".log"
        }
      }
    }
  }
}