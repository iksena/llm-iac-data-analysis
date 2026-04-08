locals {
  arnformat = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/%s"
}
data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid = "AllowKeyManagement"
    principals {
      type = "AWS"
      identifiers = formatlist(local.arnformat, [
        "RoleTerraformApplier",
        "RoleKmsAdministrator"
      ])
    }

    actions = [
      "kms:CancelKeyDeletion",
      "kms:CreateAlias",
      "kms:CreateKey",
      "kms:DeleteAlias",
      "kms:DisableKey",
      "kms:DisableKeyRotation",
      "kms:EnableKey",
      "kms:EnableKeyRotation",
      "kms:GetKeyPolicy",
      "kms:PutKeyPolicy",
      "kms:RescheduleKeyRotation",
      "kms:ScheduleKeyDeletion",
      "kms:ScheduleKeyDeletionPendingWindowInDays",
      "kms:ScheduleKeyRotation",
      "kms:UpdateKeyDescription",
      "kms:UpdateAlias"
    ]

    resources = ["arn:aws:kms:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:key/*"]
  }

  statement {
    sid = "AllowMetadataReadActions"

    principals {
      type = "AWS"
      identifiers = formatlist(local.arnformat, [
        "RoleTerraformApplier",
        "RoleKmsAdministrator",
        "RoleTerraformPlanner",
        "RoleSecurityEngineer",
        "RoleProwlerScanner",
        "RolePlatformReadOnly"
      ])
    }

    actions = [
      "kms:Describe*",
      "kms:List*",
      "kms:Get*"
    ]

    resources = ["arn:aws:kms:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:key/*"]
  }

  statement {
    sid = "AllowDecryptActions"
    principals {
      type = "AWS"
      identifiers = formatlist(local.arnformat, [
        "RolePlatformReadOnly",
        "RoleSecurityEngineer"
      ])
    }

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]

    resources = ["arn:aws:kms:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:key/*"]
  }

  statement {
    sid = "AllowCloudWatchLogsUsage"
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.region}.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = ["arn:aws:kms:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:key/*"]

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:${var.name}*"
      ]
    }
  }
}

resource "aws_kms_key" "cloudwatch" {
  policy                  = data.aws_iam_policy_document.cloudwatch.json
  enable_key_rotation     = true
  description             = "KMS key for CloudWatch logs for ${var.name} CodeBuild project"
  deletion_window_in_days = 30
  rotation_period_in_days = 90
}

resource "aws_kms_alias" "cloudwatch" {
  name_prefix   = "alias/${var.name}-cloudwatch-"
  target_key_id = aws_kms_key.cloudwatch.id
}

resource "aws_cloudwatch_log_group" "build" {
  name_prefix       = "${var.name}-"
  retention_in_days = 365
  kms_key_id        = aws_kms_alias.cloudwatch.target_key_arn
  tags              = var.tags
}
