resource "aws_s3_bucket" "static" {
  bucket = var.bucket_name
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.bucket_name}"
}

data "aws_iam_policy_document" "oai_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static_policy" {
  bucket = aws_s3_bucket.static.id
  policy = data.aws_iam_policy_document.oai_policy.json
}
