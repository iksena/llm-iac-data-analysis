data "aws_iam_policy_document" "access-logs" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.access-logs.arn,
      "${aws_s3_bucket.access-logs.arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
  statement {
    sid    = "AllowForELB" #Not used as logs are delivered to company's bucket
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.access-logs.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(var.elb-account-id, data.aws_region.current.name)}:root"]
    }
  }
  statement {
    sid    = "AllowVPCFlowLogs1"
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.access-logs.arn
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
  statement {
    sid    = "AllowVPCFlowLogs2"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.access-logs.arn}/*",
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
  statement {
    sid    = "AllowCloudFront"
    effect = "Allow"
    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.access-logs.arn,
      "${aws_s3_bucket.access-logs.arn}/*",
    ]
    principals {
      type        = "CanonicalUser"
      identifiers = ["c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"]
      #type        = "AWS"
      #identifiers = ["arn:aws:iam::162777425019:root"]
    }
  }
}

resource "aws_s3_bucket" "access-logs" {
  bucket        = "${data.aws_caller_identity.current.account_id}-${var.solution_short}-${var.env}-access-logs"
  force_destroy = true

  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.solution_short}-${var.env}-access-logs"
  }
}

resource "aws_s3_bucket_policy" "access-logs" {
  bucket = aws_s3_bucket.access-logs.id
  policy = data.aws_iam_policy_document.access-logs.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access-logs" {
  bucket = aws_s3_bucket.access-logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_alias.key-alias.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "access-logs" {
  bucket = aws_s3_bucket.access-logs.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "access-logs" {
  bucket = aws_s3_bucket.access-logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "access-logs" {
  bucket = aws_s3_bucket.access-logs.id

  rule {
    id     = "logs"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}
