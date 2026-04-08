resource "aws_kms_key" "sns" {
  description             = "KMS key for SNS Topic encryption"
  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.sns_topic_encryption_key.json
}

resource "aws_kms_alias" "sns" {
  name          = "alias/sns-${var.topic_name}"
  target_key_id = aws_kms_key.sns.id
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "sns_topic_encryption_key" {
  source_policy_documents = [
    data.aws_iam_policy_document.sns_topic_encryption_key_default.json,
    data.aws_iam_policy_document.sns_topic_encryption_key_supplementary.json
  ]
}

data "aws_iam_policy_document" "sns_topic_encryption_key_default" {
  statement {
    sid = "SnsTopicUserPermissions"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleKmsAdministrator"
      ]
    }

    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }

  statement {
    sid = "SnsTopicEncryption"

    principals {
      type = "Service"
      identifiers = [
        "sns.amazonaws.com",
        "cloudwatch.amazonaws.com",
        "s3.amazonaws.com"
      ]
    }

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }

  statement {
    principals {
      identifiers = ["codestar-notifications.amazonaws.com"]
      type        = "Service"
    }
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["sns.eu-west-2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "sns_topic_encryption_key_supplementary" {

  dynamic "statement" {
    for_each = length(local.cross_account_access_principals) > 0 ? { principals = local.cross_account_access_principals } : {}
    content {
      sid = "AllowCrossAccountAccess"

      principals {
        type        = "AWS"
        identifiers = statement.value
      }

      actions = [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ]

      resources = ["*"]
    }
  }
}
