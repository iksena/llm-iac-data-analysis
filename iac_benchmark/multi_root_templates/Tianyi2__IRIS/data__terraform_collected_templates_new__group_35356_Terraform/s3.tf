resource "random_id" "this" {
  byte_length = 8
}

resource "aws_s3_bucket" "assets" {
  bucket = "flaskapp-assets-${random_id.this.hex}"


  tags = {
    Name        = "flaskapp-assets"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "this" {
  bucket     = aws_s3_bucket.assets.id
  depends_on = [aws_s3_bucket_public_access_block.this]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })
}