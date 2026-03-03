I'll help you create a Terraform configuration that sets up an S3 bucket with SNS notifications for object creation events, specifically for .log files. The configuration will include:

1. An SNS topic for S3 event notifications
2. An IAM policy document allowing S3 to publish to the SNS topic
3. An S3 bucket configured with event notifications
4. Necessary permissions and connections between these resources

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This configuration:
1. Sets up the AWS provider for the us-east-1 region
2. Creates an SNS topic named "s3-event-notification-topic"
3. Creates an IAM policy document that allows S3 to publish to the SNS topic
4. Attaches the policy to the SNS topic
5. Creates an S3 bucket named "your-bucket-name"
6. Enables versioning on the S3 bucket
7. Configures the S3 bucket to send notifications to the SNS topic when .log files are created

The configuration includes all necessary permissions and dependencies to ensure proper functionality. The S3 bucket will only send notifications for object creation events (.log files) to the SNS topic, and the SNS topic will only accept publications from the specified S3 bucket.

Note: You should replace "your-bucket-name" with a globally unique bucket name before deploying this configuration.