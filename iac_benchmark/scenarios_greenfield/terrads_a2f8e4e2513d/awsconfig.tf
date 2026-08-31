
#
# enable default config
#
resource "aws_iam_service_linked_role" "aws_config" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_s3_bucket" "security_logs" {
  count  = var.aws_config_bucket_name == "" ? 1 : 0
  bucket = "security-logs-${data.aws_caller_identity.current.account_id}-${var.region}"
}

resource "aws_s3_bucket_public_access_block" "security_logs" {
  count                   = var.aws_config_bucket_name == "" ? 1 : 0
  bucket                  = aws_s3_bucket.security_logs[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "security_logs" {
  count  = var.aws_config_bucket_name == "" ? 1 : 0
  bucket = aws_s3_bucket.security_logs[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "security_logs_bucket" {
  count = var.aws_config_bucket_name == "" ? 1 : 0
  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.security_logs[0].arn]
  }
  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.security_logs[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.security_logs[0].arn]
  }
  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.security_logs[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "security_logs" {
  count  = var.aws_config_bucket_name == "" ? 1 : 0
  bucket = aws_s3_bucket.security_logs[0].id
  policy = data.aws_iam_policy_document.security_logs_bucket[0].json
}

locals {
  effective_config_bucket_name = var.aws_config_bucket_name != "" ? var.aws_config_bucket_name : aws_s3_bucket.security_logs[0].id
}

resource "aws_config_configuration_recorder" "security_recorder" {
  name     = "security_recorder"
  role_arn = aws_iam_service_linked_role.aws_config.arn
}

resource "aws_config_delivery_channel" "security_delivery_channel" {
  name           = "security_delivery_channel"
  s3_bucket_name = local.effective_config_bucket_name
  depends_on     = [aws_config_configuration_recorder.security_recorder, aws_s3_bucket_policy.security_logs]
}

resource "aws_config_configuration_recorder_status" "security_recorder" {
  name       = aws_config_configuration_recorder.security_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.security_delivery_channel]
}

#
# config rules
#
# identity can be find in aws rule detail page
#
resource "aws_config_config_rule" "iam-password-policy" {
  name = "iam-password-policy"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "cloudtrail-enabled" {
  name = "cloudtrail-enabled"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "securityhub-enabled" {
  name = "securityhub-enabled"

  source {
    owner             = "AWS"
    source_identifier = "SECURITYHUB_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "iam-user-mfa-enabled" {
  name = "iam-user-mfa-enabled"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_MFA_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "iam-root-access-key-check" {
  name = "iam-root-access-key-check"

  source {
    owner             = "AWS"
    source_identifier = "IAM_ROOT_ACCESS_KEY_CHECK"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "root-account-mfa-enabled" {
  name = "root-account-mfa-enabled"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "iam-user-unused-credentials-check" {
  name = "iam-user-unused-credentials-check"

  source {
    owner             = "AWS"
    source_identifier = "IAM_ROOT_ACCESS_KEY_CHECK"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "security-account-information-provided" {
  name = "security-account-information-provided"

  source {
    owner             = "AWS"
    source_identifier = "SECURITY_ACCOUNT_INFORMATION_PROVIDED"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "mfa-enabled-for-iam-console-access" {
  name = "mfa-enabled-for-iam-console-access"

  source {
    owner             = "AWS"
    source_identifier = "MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "access-keys-rotated" {
  name = "access-keys-rotated"

  source {
    owner             = "AWS"
    source_identifier = "ACCESS_KEYS_ROTATED"
  }

  input_parameters = jsonencode({
      maxAccessKeyAge = "90"
    })

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "api-gw-associated-with-waf" {
  name = "api-gw-associated-with-waf"

  source {
    owner             = "AWS"
    source_identifier = "API_GW_ASSOCIATED_WITH_WAF"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "alb-waf-enabled" {
  name = "alb-waf-enabled"

  source {
    owner             = "AWS"
    source_identifier = "ALB_WAF_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}

resource "aws_config_config_rule" "guardduty-enabled-centralized" {
  name = "guardduty-enabled-centralized"

  source {
    owner             = "AWS"
    source_identifier = "GUARDDUTY_ENABLED_CENTRALIZED"
  }

  depends_on = [aws_config_configuration_recorder.security_recorder]
}