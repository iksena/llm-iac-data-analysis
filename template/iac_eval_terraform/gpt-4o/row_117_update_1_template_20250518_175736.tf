provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "s3_event_notification_topic" {
  name = "s3-event-notification-topic"
}

resource "aws_s3_bucket" "your_bucket" {
  bucket = "your-bucket-name"

  notification {
    topic {
      topic_arn = aws_sns_topic.s3_event_notification_topic.arn
      events    = ["s3:ObjectCreated:*"]

      filter_suffix {
        suffix = ".log"
      }
    }
  }
}

data "aws_iam_policy_document" "s3_to_sns" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["SNS:Publish"]

    resources = [aws_sns_topic.s3_event_notification_topic.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.your_bucket.arn]
    }
  }
}

resource "aws_sns_topic_policy" "s3_event_notification_policy" {
  arn    = aws_sns_topic.s3_event_notification_topic.arn
  policy = data.aws_iam_policy_document.s3_to_sns.json
}