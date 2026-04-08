locals {
  cross_account_access_principals = formatlist("arn:aws:iam::%s:root", var.subscriber_account_numbers)
}

resource "aws_sns_topic" "this" {
  name              = var.topic_name
  display_name      = var.topic_name
  kms_master_key_id = aws_kms_alias.sns.name

  tags = var.tags
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  override_policy_documents = var.override_policy_json == null ? null : [var.override_policy_json]

  statement {
    sid     = "CodestarPublish"
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["codestar-notifications.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.this.arn,
    ]
  }

  statement {
    sid     = "CodePipelinePublish"
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.this.arn,
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
      aws_sns_topic.this.arn,
    ]

    condition {
      test     = "StringLike"
      variable = "SNS:Endpoint"
      values   = ["*@digital.hmrc.gov.uk"]
    }
  }

  dynamic "statement" {
    for_each = length(local.cross_account_access_principals) > 0 ? { principals = local.cross_account_access_principals } : {}
    content {
      sid = "AllowSubscriptionsFromOtherAccounts"

      principals {
        type        = "AWS"
        identifiers = statement.value
      }

      actions = [
        "SNS:Subscribe",
      ]

      effect = "Allow"

      resources = [aws_sns_topic.this.arn]
    }
  }
}
