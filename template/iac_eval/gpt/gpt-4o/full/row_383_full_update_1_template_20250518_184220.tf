To fulfill the business need, we will create an AWS S3 Glacier vault and integrate it with an AWS SNS topic for notifications. The configuration will include the creation of an SNS topic, an IAM role with the necessary permissions for Glacier to publish notifications to the SNS topic, and the Glacier vault itself with the notification configuration pointing to the SNS topic. We will use the AWS provider and set the region to `us-east-1`.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "glacier_notifications" {
  name = "glacier-notifications"
}

resource "aws_iam_role" "glacier_sns_role" {
  name = "glacier-sns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glacier.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "glacier_sns_policy" {
  name = "glacier-sns-policy"
  role = aws_iam_role.glacier_sns_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sns:Publish"
        Effect = "Allow"
        Resource = aws_sns_topic.glacier_notifications.arn
      }
    ]
  })
}

resource "aws_glacier_vault" "example" {
  name = "example-vault"

  notification {
    events = ["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"]
    sns_topic = aws_sns_topic.glacier_notifications.arn
  }
}
```
</iac_template>

This configuration sets up an SNS topic for notifications, an IAM role with a policy allowing Glacier to publish to the SNS topic, and a Glacier vault with notifications enabled for specific events.