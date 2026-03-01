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