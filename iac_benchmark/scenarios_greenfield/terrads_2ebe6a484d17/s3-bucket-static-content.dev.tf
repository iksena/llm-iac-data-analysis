# Static content bucket
# Note that this one doesn't use the default provider
resource "aws_s3_bucket" "dev_static_content" {
  provider = aws.us_west_2
  bucket   = "utkusarioglu-com-dev-static-content"
}

resource "aws_s3_bucket_website_configuration" "dev_static_content" {
  depends_on = [
    aws_s3_bucket.dev_static_content
  ]
  provider = aws.us_west_2
  bucket   = aws_s3_bucket.dev_static_content.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  # routing_rule {
  #   redirect {
  #   host_name = "dev.${local.domain_name}"
  #     replace_key_prefix_with = "/"
  #   }
  # } 
}

resource "aws_s3_bucket_cors_configuration" "dev_static_content" {
  depends_on = [
    aws_s3_bucket.dev_static_content
  ]
  provider = aws.us_west_2
  bucket   = aws_s3_bucket.dev_static_content.bucket

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://dev.${local.domain_name}"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "dev_static_content" {
  depends_on = [
    aws_s3_bucket.dev_static_content
  ]
  provider = aws.us_west_2
  bucket   = aws_s3_bucket.dev_static_content.bucket
  policy   = data.aws_iam_policy_document.dev_static_content_public_read.json
}
