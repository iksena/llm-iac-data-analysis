provider "aws" {
  region = var.region
}

# ${data.aws_region.current.name}
data "aws_region" "current" {}

# ${data.aws_caller_identity.current.account_id}
data "aws_caller_identity" "current" {}

# ${data.aws_partition.current.partition}  , for `ARN`
data "aws_partition" "current" {}

# for SNS topic and subscript
resource "aws_sns_topic" "security_events" {
  name = "security-events-topic"
}

resource "aws_sns_topic_policy" "security_events" {
  arn = aws_sns_topic.security_events.arn
  policy = data.aws_iam_policy_document.security_events_policy.json
}

# resource "aws_sns_topic_subscription" "security_notification" {
#   topic_arn = aws_sns_topic.security_events.arn
#   protocol  = "email"
#   for_each = toset(var.admin_email)
#   endpoint  = each.value
# }

data "aws_iam_policy_document" "security_events_policy" {
  policy_id = "__default_policy_ID"
  
  statement {
    sid = "allow_sns_public_of_event_bridge"
    actions = ["sns:Publish"]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [
      aws_sns_topic.security_events.arn,
    ]
  }

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.security_events.arn,
    ]

    sid = "__default_statement_ID"
  }
}

# rule for security hub finds , @ event bridge
resource "aws_cloudwatch_event_rule" "security_hub_event" {
  name        = "security_hub_events"
  description = "Capture security hub events"

  event_pattern = jsonencode({
    "source": [
        "aws.securityhub"
    ],
    "detail-type": [
        "Security Hub Findings - Imported"
    ],
    "detail": {
        "findings": {
            "Severity": {
                "Label": ["CRITICAL", "HIGH", "MEDIUM"]
            }
        }
    }
    })
}

resource "aws_cloudwatch_event_target" "security_hub_notify" {
  rule      = aws_cloudwatch_event_rule.security_hub_event.name
  target_id = "iam_event_notify"
  arn       = aws_sns_topic.security_events.arn
}

# for enable security hub
resource "aws_securityhub_account" "default" {}

# for GuardDuty
resource "aws_guardduty_detector" "basic_guardduty" {
  enable = true
}

resource "aws_guardduty_detector_feature" "rds_login_events" {
  detector_id = aws_guardduty_detector.basic_guardduty.id
  name        = "RDS_LOGIN_EVENTS"
  status      = "ENABLED"
}

resource "aws_guardduty_detector_feature" "s3_data_events" {
  detector_id = aws_guardduty_detector.basic_guardduty.id
  name        = "S3_DATA_EVENTS"
  status      = "ENABLED"
}

#
# for cloudwatch in s3 bucket
#
resource "aws_cloudtrail" "security_trail" {
  name                          = "security_trail"
  s3_bucket_name                = local.effective_config_bucket_name
  s3_key_prefix                 = var.region
  include_global_service_events = var.region == "us-east-1" ? true : false
  depends_on                    = [aws_s3_bucket_policy.security_logs]
}
