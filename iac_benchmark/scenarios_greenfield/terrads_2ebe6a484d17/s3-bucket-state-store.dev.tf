# State store
resource "aws_s3_bucket" "dev_state_store" {
  provider = aws.eu_central_1
  bucket   = "utkusarioglu-com-dev-state-store"
  tags     = local.dev_tags
}

resource "aws_s3_bucket_versioning" "dev_state_store" {
  bucket = aws_s3_bucket.dev_state_store.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "dev_state_store" {
  provider = aws.eu_central_1
  bucket   = aws_s3_bucket.dev_state_store.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
