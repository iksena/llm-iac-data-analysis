The Terraform program will create an AWS SNS topic named 's3-event-notification-topic' and an S3 bucket named 'your-bucket-name'. It will define an IAM policy that allows the 's3.amazonaws.com' service to publish to the SNS topic, but only if the source ARN matches the ARN of the specified S3 bucket. The S3 bucket will be configured to send notifications to the SNS topic for 's3:ObjectCreated:*' events, specifically for objects with a '.log' suffix.

<iac_template>

```hcl
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
```

</iac_template>