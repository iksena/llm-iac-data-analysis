provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Name       = "hello-fis"
      Repository = "https://github.com/ericdahl/hello-fis"
    }
  }
}

data "aws_default_tags" "default" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  name = data.aws_default_tags.default.tags["Name"]
}

resource "aws_s3_bucket" "fis_logs" {

  force_destroy = true
}

resource "aws_s3_bucket_policy" "fis_logs" {
  bucket = aws_s3_bucket.fis_logs.bucket
  policy = data.aws_iam_policy_document.bucket_policy_fis_logs.json
}

data "aws_iam_policy_document" "bucket_policy_fis_logs" {
  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.fis_logs.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"]
    }
  }

  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.fis_logs.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
}
