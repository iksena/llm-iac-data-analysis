resource "random_pet" "iam_role_name" {
  length    = 2
  separator = "-"
}
resource "aws_iam_role" "canary_execution_role" {
  name = "${random_pet.iam_role_name.id}-canary"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_policy" "canary_execution_policy" {
  name        = "${random_pet.iam_role_name.id}-canary-policy"
  description = "Policy for executing canaries"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "s3-object-lambda:*",
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "canary_execution_attachment" {
  role       = aws_iam_role.canary_execution_role.name
  policy_arn = aws_iam_policy.canary_execution_policy.arn
}

/////////////////--KMS-KEY----//////////////////////////////
module "kms" {
  source                  = "sourcefuse/arc-kms/aws"
  version                 = "0.0.4"
  enabled                 = var.enabled
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  alias                   = var.kms_key_alias
  tags                    = var.tags
  policy                  = var.custom_kms_policy != "" ? var.custom_kms_policy : local.kms_policy
}

/////////////////--SNS----//////////////////////////////

resource "aws_sns_topic" "this" {
  name              = var.sns_topic_name
  kms_master_key_id = var.enabled ? module.kms.key_arn : null
  tags              = var.tags
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}
resource "aws_synthetics_canary" "dynamic_canaries_with_vpc" {
  for_each = local.canaries_with_vpc

  name                     = each.value.name
  artifact_s3_location     = "s3://${aws_s3_bucket.artifcats_bucket.id}/"
  execution_role_arn       = data.aws_iam_role.execution_role.arn
  handler                  = each.value.handler
  runtime_version          = each.value.runtime_version
  start_canary             = each.value.start_canary
  failure_retention_period = each.value.failure_retention_period
  success_retention_period = each.value.success_retention_period

  schedule {
    expression = each.value.schedule_expression
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  run_config {
    timeout_in_seconds    = 120
    environment_variables = each.value.environment_variables
  }

  # Conditional attributes
  zip_file   = each.value.zip_file
  s3_bucket  = each.value.s3_bucket
  s3_key     = each.value.s3_key
  s3_version = each.value.s3_version

  depends_on = [aws_s3_bucket.artifcats_bucket]
  tags       = var.tags
}

resource "aws_cloudwatch_metric_alarm" "fail_alarm" {
  for_each = var.canaries_with_vpc

  alarm_name          = "${each.value.name}-fail-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Failed"
  namespace           = "CloudWatchSynthetics"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  actions_enabled     = true

  dimensions = {
    CanaryName = each.value.name
  }

  alarm_actions     = [aws_sns_topic.this.arn]
  alarm_description = "Canary is down: ${each.value.name}"
  tags              = var.tags
  depends_on        = [aws_sns_topic.this]
}

resource "aws_cloudwatch_metric_alarm" "success_alarm" {
  for_each            = var.cloudwatch_metric_alarms_enabled ? var.canaries_with_vpc : {}
  alarm_name          = "${each.value.name}-success-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "SuccessPercent"
  namespace           = "CloudWatchSynthetics"
  period              = "60"
  statistic           = "Average"
  threshold           = "90"
  actions_enabled     = true

  dimensions = {
    CanaryName = each.value.name
  }
  ok_actions        = [aws_sns_topic.this.arn]
  alarm_description = "Canary is up: ${each.value.name}"
  tags              = var.tags
  depends_on        = [aws_sns_topic.this]
}
////////////////// s3 ////////////////////////

resource "aws_s3_bucket" "artifcats_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.artifcats_bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
resource "aws_s3_bucket_server_side_encryption_configuration" "ssm" {
  bucket = aws_s3_bucket.artifcats_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = module.kms.key_arn
      sse_algorithm     = var.sse_algorithm
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.artifcats_bucket.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}
resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.artifcats_bucket.id

  dynamic "cors_rule" {
    for_each = var.cors_configuration
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}
