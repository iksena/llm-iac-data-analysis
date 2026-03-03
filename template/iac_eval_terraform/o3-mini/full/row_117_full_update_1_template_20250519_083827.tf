Description:
This Terraform configuration sets up an SNS topic and an S3 bucket configured for event notifications. An IAM policy document is defined as an inline SNS topic access policy. The policy allows the "s3.amazonaws.com" service, acting on behalf of S3, to execute the SNS:Publish action on the SNS topic "s3-event-notification-topic." The policy includes a condition to restrict the publishing to only events where the source ARN matches the S3 bucket ("your-bucket-name"). The SNS topic is created with this access policy attached, and an S3 bucket is defined. The S3 bucket is then configured to send notifications to the SNS topic for the "s3:ObjectCreated:*" event with a filter for objects with a ".log" suffix.

<iac_template>
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
</iac_template>