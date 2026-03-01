To fulfill the business need, we will create an AWS S3 Glacier vault and configure it to send notifications to an SNS topic whenever a job is completed. This setup will involve creating an S3 Glacier vault, an SNS topic, and the necessary IAM roles and policies to allow Glacier to publish notifications to the SNS topic. We will also configure the SNS topic to send notifications to an email endpoint.

Here is the Terraform HCL configuration:

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "glacier_notifications" {
  name = "glacier-job-completion-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.glacier_notifications.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"  # Replace with your email address
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
  name   = "glacier-sns-policy"
  role   = aws_iam_role.glacier_sns_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sns:Publish"
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

This configuration will set up an S3 Glacier vault with a notification service that sends job completion notifications to an SNS topic, which in turn sends an email to the specified address. Make sure to replace `"your-email@example.com"` with the actual email address where you want to receive notifications.