data "aws_iam_policy_document" "dev_static_content_public_read" {
  provider = aws.us_west_2
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.dev_static_content.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:Referer"
      values   = [var.referer_value]
    }
  }
}
