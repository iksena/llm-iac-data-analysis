To fulfill the business need, we will create an AWS S3 Glacier vault and configure it to send notifications to an SNS topic when an archive retrieval is completed. We will also create an IAM role that allows the Glacier vault to publish messages to the SNS topic. The Terraform configuration will include the necessary resources such as the Glacier vault, SNS topic, and IAM role with the appropriate policy.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "glacier_notifications" {
  name = "glacier-archive-retrieval-completed"
}

resource "aws_iam_role" "glacier_sns_role" {
  name = "glacier-sns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glacier.amazonaws.com"
        }
        Action = "sts:AssumeRole"
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
    events = ["ArchiveRetrievalCompleted"]
    sns_topic = aws_sns_topic.glacier_notifications.arn
  }
}

output "sns_topic_arn" {
  value = aws_sns_topic.glacier_notifications.arn
}

output "glacier_vault_name" {
  value = aws_glacier_vault.example.name
}
```

</iac_template>

This configuration sets up an S3 Glacier vault with a notification configuration that triggers an SNS topic when an archive retrieval is completed. The IAM role and policy allow the Glacier service to publish messages to the SNS topic.