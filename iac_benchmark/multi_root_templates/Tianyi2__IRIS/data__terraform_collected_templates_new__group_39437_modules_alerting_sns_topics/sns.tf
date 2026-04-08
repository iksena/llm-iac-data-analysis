resource "aws_sns_topic" "sns_topic" {
  name         = var.topic_name
  display_name = var.topic_name

  tags = var.tags
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn    = aws_sns_topic.sns_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy_doc.json
}

data "aws_iam_policy_document" "sns_topic_policy_doc" {
  statement {
    sid     = "CodestarPublish"
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["codestar-notifications.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.sns_topic.arn,
    ]
  }

  statement {
    sid = "SnsTopicSubscriptionCondition"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "sns:Subscribe"
    ]

    resources = [
      aws_sns_topic.sns_topic.arn,
    ]

    condition {
      test     = "StringLike"
      variable = "SNS:Endpoint"
      values   = ["*@digital.hmrc.gov.uk"]
    }
  }

  statement {
    sid = "AllowSubscriptionsFromOtherAccounts"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.subscription_account_no}:root"
      ]
    }

    actions = [
      "SNS:Subscribe",
      "SNS:Receive",
    ]

    effect = "Allow"

    resources = [aws_sns_topic.sns_topic.arn]
  }
}
