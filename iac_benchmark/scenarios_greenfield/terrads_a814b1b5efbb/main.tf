data "aws_canonical_user_id" "current" {}

locals {
  # See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  awslogsdelivery_canonical_id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
  grant_ids                    = var.enable_cloudfront_access ? [local.awslogsdelivery_canonical_id, data.aws_canonical_user_id.current.id] : []
  acl                          = var.enable_cloudfront_access ? null : var.acl
  expiration_days              = var.expiration_days > 0 ? var.expiration_days : null
  version_expiration_days      = var.version_expiration_days > 0 ? var.version_expiration_days : null
}

resource "aws_s3_bucket" "s3" {
  count         = var.create ? 1 : 0
  bucket        = var.name
  force_destroy = var.force_destroy
  tags          = merge(var.tags, var.s3_tags)
}

resource "aws_s3_bucket_ownership_controls" "s3" {
  count  = var.create && var.ownership != null ? 1 : 0
  bucket = aws_s3_bucket.s3[count.index].id
  rule {
    object_ownership = var.ownership
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  count  = var.create ? 1 : 0
  bucket = aws_s3_bucket.s3[count.index].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_master_key_id == null ? "AES256" : "aws:kms"
      kms_master_key_id = var.kms_master_key_id
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "expiration" {
  count  = var.create && local.expiration_days != null ? 1 : 0
  bucket = aws_s3_bucket.s3[count.index].id
  rule {
    id     = "expiration_policy"
    status = "Enabled"
    expiration {
      days = local.expiration_days
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "version_expiration" {
  count  = var.create && var.versioning && local.version_expiration_days != null ? 1 : 0
  bucket = aws_s3_bucket.s3[count.index].id
  rule {
    id     = "version_expiration_policy"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = local.version_expiration_days
    }
  }
}

resource "aws_s3_bucket_acl" "acl" {
  count      = var.create && length(local.grant_ids) == 0 ? 1 : 0
  bucket     = aws_s3_bucket.s3[count.index].id
  acl        = var.acl
  depends_on = [aws_s3_bucket_ownership_controls.s3]
}

resource "aws_s3_bucket_acl" "acp" {
  count  = var.create && length(local.grant_ids) > 0 ? 1 : 0
  bucket = aws_s3_bucket.s3[count.index].id
  access_control_policy {
    dynamic "grant" {
      for_each = local.grant_ids
      content {
        grantee {
          type = "CanonicalUser"
          id   = grant.value
        }
        permission = "FULL_CONTROL"
      }
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
  depends_on = [aws_s3_bucket_ownership_controls.s3]
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.create && var.versioning ? 1 : 0
  bucket = aws_s3_bucket.s3[count.index].id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3" {
  count                   = var.create ? 1 : 0
  bucket                  = aws_s3_bucket.s3[count.index].id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  ignore_public_acls      = var.ignore_public_acls
}

resource "aws_iam_policy" "rw" {
  count       = var.create ? 1 : 0
  name        = "${var.name}-read-write"
  path        = var.path
  description = "Read-write access to S3 bucket ${var.name}"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ReadWrite",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "${join("", aws_s3_bucket.s3.*.arn)}",
                "${join("", aws_s3_bucket.s3.*.arn)}/*"
            ]
        },
        {
            "Sid": "List",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${join("", aws_s3_bucket.s3.*.arn)}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ro" {
  count       = var.create ? 1 : 0
  name        = "${var.name}-read-only"
  path        = var.path
  description = "Read-only access to S3 bucket ${var.name}"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ReadOnly",
            "Effect": "Allow",
            "Action": [
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "${join("", aws_s3_bucket.s3.*.arn)}",
                "${join("", aws_s3_bucket.s3.*.arn)}/*"
            ]
        },
        {
            "Sid": "List",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${join("", aws_s3_bucket.s3.*.arn)}"
        }
    ]
}
EOF
}

resource "aws_iam_user" "rw" {
  count = var.create && var.create_rw_user ? 1 : 0
  name  = var.rw_user_name == null ? "${var.name}-rw" : var.rw_user_name
  path  = var.path
  tags  = merge(var.tags, var.rw_user_tags)
}

resource "aws_iam_user_policy_attachment" "rw" {
  count      = var.create && var.create_rw_user ? 1 : 0
  policy_arn = aws_iam_policy.rw[count.index].arn
  user       = aws_iam_user.rw[count.index].name
}

resource "aws_iam_user" "ro" {
  count = var.create && var.create_ro_user ? 1 : 0
  name  = var.ro_user_name == null ? "${var.name}-ro" : var.ro_user_name
  path  = var.path
  tags  = merge(var.tags, var.ro_user_tags)
}

resource "aws_iam_user_policy_attachment" "ro" {
  count      = var.create && var.create_ro_user ? 1 : 0
  policy_arn = aws_iam_policy.ro[count.index].arn
  user       = aws_iam_user.ro[count.index].name
}

data "aws_iam_policy_document" "bucket_notification_topic_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["s3.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sns:Publish"]
    resources = [
      "arn:aws:sns:*:*:${var.name}-notifications"
    ]
    condition {
      test     = "ArnLike"
      values   = [join("", aws_s3_bucket.s3.*.arn)]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_sns_topic" "bucket_notification_topic" {
  count  = var.create && var.create_bucket_notification_topic ? 1 : 0
  name   = "${var.name}-notifications"
  policy = data.aws_iam_policy_document.bucket_notification_topic_policy.json
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = var.create && var.create_bucket_notification_topic ? 1 : 0
  bucket = aws_s3_bucket.s3[count.index].id
  topic {
    events    = ["s3:ObjectCreated:*"]
    topic_arn = aws_sns_topic.bucket_notification_topic[count.index].arn
  }
}
