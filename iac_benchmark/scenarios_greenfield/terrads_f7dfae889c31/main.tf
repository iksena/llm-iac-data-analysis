
resource "aws_s3_bucket" "this" {
  // checkov:skip=CKV_AWS_144: Not yet supported
  // checkov:skip=CKV2_AWS_6: Moved to resource `aws_s3_bucket_public_access_block`
  // checkov:skip=CKV_AWS_21: User defined input
  // checkov:skip=CKV_AWS_18: User defined input
  // checkov:skip=CKV_AWS_145: User defined input
  // checkov:skip=CKV_AWS_19: User defined input
  bucket        = local.use_prefix ? null : local.bucket_name
  bucket_prefix = local.use_prefix ? local.bucket_name : null
  force_destroy = local.force_destroy

  tags = local.labels.tags
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count = length(local.config_cors.rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = local.config_cors.rules

    content {
      allowed_headers = lookup(each.value, "allowed_headers", [])
      allowed_methods = lookup(each.value, "allowed_methods", [])
      allowed_origins = lookup(each.value, "allowed_origins", [])
      expose_headers  = lookup(each.value, "expose_headers", [])
    }
  }
}

resource "aws_s3_bucket_logging" "this" {
  for_each = local.config_logging.buckets

  bucket = aws_s3_bucket.this.id

  target_bucket = each.value["target_bucket"]
  target_prefix = coalesce(try(each.value.target_prefix, null), "${aws_s3_bucket.this.id}/")
}

resource "aws_s3_bucket_acl" "this" {
  count  = local.acl != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  acl    = local.acl
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this_aes" {
  count  = local.sse_config.type == "aws:kms" ? 0 : 1
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = local.sse_config.type
    }
  }
}

resource "aws_kms_key" "this" {
  count                   = local.sse_config.type == "aws:kms" && local.sse_config.kms_master_key_id == null ? 1 : 0
  description             = "KMS key used for ${aws_s3_bucket.this.id} encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

data "aws_kms_key" "this" {
  count  = local.sse_config.type == "aws:kms" ? 1 : 0
  key_id = local.sse_config.kms_master_key_id == null ? aws_kms_key.this.0.arn : local.sse_config.kms_master_key_id
}

resource "aws_kms_alias" "this" {
  count = local.sse_config.type == "aws:kms" && local.sse_config.alias != null ? 1 : 0

  name          = local.sse_config.alias
  target_key_id = data.aws_kms_key.this.0.id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this_kms" {
  count = local.sse_config.type == "aws:kms" ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = local.sse_config.type
      kms_master_key_id = data.aws_kms_key.this.0.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = local.enable_versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  // checkov:skip=CKV_AWS_53: User defined input
  // checkov:skip=CKV_AWS_54: User defined input
  // checkov:skip=CKV_AWS_55: User defined input
  // checkov:skip=CKV_AWS_56: User defined input
  bucket                  = aws_s3_bucket.this.id
  block_public_policy     = local.public_access_block["block_public_policy"]
  block_public_acls       = local.public_access_block["block_public_acls"]
  restrict_public_buckets = local.public_access_block["restrict_public_buckets"]
  ignore_public_acls      = local.public_access_block["ignore_public_acls"]
}

locals {
  kms_actions = local.sse_config.type == "aws:kms" ? [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:ReEncrypt*",
    "kms:GenerateDataKey*",
    "kms:DescribeKey",
  ] : []
  kms_resources = local.sse_config.type == "aws:kms" ? [
    data.aws_kms_key.this.0.arn
  ] : []
}

data "aws_iam_policy_document" "this_ro" {
  count = local.config_iam.enable ? 1 : 0

  statement {
    sid    = "${local.sid_name}S3RO"
    effect = "Allow"

    actions = concat([
      "s3:GetObject*",
      "s3:List*"
    ], local.kms_actions)

    resources = concat([
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
      ], local.kms_resources
    )

    dynamic "condition" {
      for_each = try(local.config_iam.policy_conditions.ro, {})

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

data "aws_iam_policy_document" "this_rw" {
  count = local.config_iam.enable ? 1 : 0

  statement {
    sid    = "${local.sid_name}S3RW"
    effect = "Allow"

    actions = concat([
      "s3:*"
    ], local.kms_actions)

    resources = concat([
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ], local.kms_resources)

    dynamic "condition" {
      for_each = try(local.config_iam.policy_conditions.rw, {})

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

resource "aws_iam_policy" "this_rw" {
  count = local.config_iam.enable ? 1 : 0

  name   = join("-", [aws_s3_bucket.this.id, "rw"])
  policy = data.aws_iam_policy_document.this_rw[0].json
}

resource "aws_iam_policy" "this_ro" {
  count = local.config_iam.enable ? 1 : 0

  name   = join("-", [aws_s3_bucket.this.id, "ro"])
  policy = data.aws_iam_policy_document.this_ro[0].json
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = local.groups

  group      = each.value.name
  policy_arn = each.value.mode == "rw" ? aws_iam_policy.this_rw[0].arn : aws_iam_policy.this_ro[0].arn
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.roles

  role       = each.value.name
  policy_arn = each.value.mode == "rw" ? aws_iam_policy.this_rw[0].arn : aws_iam_policy.this_ro[0].arn
}

resource "aws_s3_bucket_policy" "this" {
  count = length(local.config_iam.bucket_policy) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = local.config_iam.bucket_policy
}
