data "aws_region" "current" {}

data "aws_kms_key" "sns_default" {
  key_id = "alias/aws/sns"
}

locals {
  sns_kms_key_id = var.sns_kms_key_id != "" ? var.sns_kms_key_id : data.aws_kms_key.sns_default.id
}

######################
# IAM ROLE
######################
data "aws_iam_policy_document" "assume_role" {
  count = var.create_iam_role ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "config" {
  count = var.create_iam_role ? 1 : 0
  name  = "aws-config-role-${data.aws_region.current.name}"
  tags  = local.common_tags

  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "config" {
  count      = var.create_iam_role ? 1 : 0
  provider   = aws
  role       = aws_iam_role.config[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

#######
# SNS
#######
data "aws_iam_policy_document" "config_sns_policy" {
  count = var.create_iam_role && var.create_sns_topic ? 1 : 0

  statement {
    sid       = "ConfigSNS"
    effect    = "Allow"
    resources = [aws_sns_topic.aws_config_stream[0].arn]
    actions = [
      "sns:Publish"
    ]
  }
}
resource "aws_iam_policy" "config_sns_policy" {
  count       = var.create_iam_role && var.create_sns_topic ? 1 : 0
  name        = "config_sns_policy"
  description = "Allows AWS Config publish to the SNS topic"
  policy      = data.aws_iam_policy_document.config_sns_policy[0].json
}
resource "aws_iam_role_policy_attachment" "config_sns_policy" {
  count      = var.create_iam_role && var.create_sns_topic ? 1 : 0
  role       = aws_iam_role.config[0].name
  policy_arn = aws_iam_policy.config_sns_policy[0].arn
}

#tfsec:ignore:aws-sns-enable-topic-encryption -- Ignores error on Turning on SNS Topic encryption.
resource "aws_sns_topic" "aws_config_stream" {
  count = var.create_sns_topic ? 1 : 0

  name              = "aws-config-stream-${data.aws_region.current.name}"
  kms_master_key_id = local.sns_kms_key_id
  tags              = local.common_tags
}

data "aws_iam_policy_document" "config_sns" {
  count = var.create_sns_topic ? 1 : 0
  statement {
    actions = [
      "sns:Publish",
    ]
    principals {
      identifiers = [
        "config.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      aws_sns_topic.aws_config_stream[0].arn,
    ]
    sid = "ConfigSNSPolicy"
  }
  statement {
    actions = [
      "sns:Publish",
    ]
    condition {
      test = "Bool"
      values = [
        "false",
      ]
      variable = "aws:SecureTransport"
    }
    effect = "Deny"
    principals {
      identifiers = [
        "*",
      ]
      type = "AWS"
    }
    resources = [
      aws_sns_topic.aws_config_stream[0].arn,
    ]
    sid = "DenyUnsecuredTransport"
  }
}

resource "aws_sns_topic_policy" "config" {
  count  = var.create_sns_topic ? 1 : 0
  arn    = aws_sns_topic.aws_config_stream[0].arn
  policy = data.aws_iam_policy_document.config_sns[0].json
}

resource "aws_sns_topic_subscription" "this" {
  for_each = local.conditional_subscribers

  topic_arn = aws_sns_topic.aws_config_stream[0].arn


  protocol               = lookup(each.value, "protocol")
  endpoint               = lookup(each.value, "endpoint")
  endpoint_auto_confirms = lookup(each.value, "endpoint_auto_confirms", false)
  raw_message_delivery   = lookup(each.value, "raw_message_delivery", false)

}

##########################
# RECORDER
##########################
resource "aws_config_configuration_recorder" "config" {
  name = "aws-config-recorder"
  # required argument, an arn of a valid role should be pass if the role is not created
  role_arn = var.create_iam_role ? aws_iam_role.config[0].arn : var.iam_role_arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = var.include_global_resource_types
  }

  dynamic "recording_mode" {
    for_each = var.recording_mode != null ? [1] : []
    content {
      recording_frequency = var.recording_mode.recording_frequency
      dynamic "recording_mode_override" {
        for_each = var.recording_mode.recording_mode_override != null ? [1] : []
        content {
          description         = var.recording_mode.recording_mode_override.description
          resource_types      = var.recording_mode.recording_mode_override.resource_types
          recording_frequency = var.recording_mode.recording_mode_override.recording_frequency
        }
      }
    }
  }
}

##########################
# DELIVERY CHANNEL
##########################

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "config" {
  count  = var.log_bucket_id == "" ? 1 : 0
  bucket = "aws-config-log-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  tags   = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "config" {
  count                   = var.log_bucket_id == "" ? 1 : 0
  bucket                  = aws_s3_bucket.config[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  count  = var.log_bucket_id == "" ? 1 : 0
  bucket = aws_s3_bucket.config[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "config_bucket" {
  count = var.log_bucket_id == "" ? 1 : 0
  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.config[0].arn]
  }
  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.config[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "config" {
  count  = var.log_bucket_id == "" ? 1 : 0
  bucket = aws_s3_bucket.config[0].id
  policy = data.aws_iam_policy_document.config_bucket[0].json
}

locals {
  effective_log_bucket_id = var.log_bucket_id != "" ? var.log_bucket_id : aws_s3_bucket.config[0].id
}

resource "aws_config_delivery_channel" "config" {
  provider       = aws
  name           = "aws-config-delivery-channel"
  s3_bucket_name = local.effective_log_bucket_id
  # To maintain bakcward compatibility with the previous version
  s3_key_prefix = var.s3_key_prefix != null ? var.s3_key_prefix : "config"
  sns_topic_arn = var.create_sns_topic == true ? aws_sns_topic.aws_config_stream[0].arn : ""

  dynamic "snapshot_delivery_properties" {
    # To maintain bakcward compatibility with the previous version the default value of snapshot_delivery_frequency where leave as is
    for_each = var.snapshot_delivery_frequency != null && var.snapshot_delivery_frequency != "" ? [1] : []

    content {
      delivery_frequency = var.snapshot_delivery_frequency
    }

  }

  depends_on = [aws_config_configuration_recorder.config, aws_s3_bucket_policy.config]
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = aws_config_configuration_recorder.config.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.config]
}



######################
# CONFIG AGGREGATOR
######################

resource "aws_config_configuration_aggregator" "this" {
  # Create the aggregator in the global recorder region of the central AWS Config account.
  count = var.is_global_recorder_region_and_account ? 1 : 0

  name = "aws-config-aggregator-${data.aws_region.current.name}"

  # Create normal account aggregation source
  account_aggregation_source {
    account_ids = var.source_collector_accounts
    regions     = var.source_collector_all_regions == true ? null : var.source_collector_regions
    all_regions = var.source_collector_all_regions
  }

}

resource "aws_config_aggregate_authorization" "source" {
  # This resource grants permission to the aggregator account to access AWS Config data from the source account.
  # Enable it only in the source account, it's not needed for the aggregator account.
  count = var.central_resource_collector_account != null ? 1 : 0

  account_id = var.central_resource_collector_account
  region     = var.global_resource_collector_region

}
locals {
  # Conditionally create a map of subscribers if the SNS topic is created
  conditional_subscribers = var.create_sns_topic ? { for key, value in var.subscribers : key => value } : {}
}
