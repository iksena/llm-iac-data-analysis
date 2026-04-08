provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name

  tags = {
    Name     = "Static Website Bucket"
    Endpoint = "http://${var.bucket_name}"
  }
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "www.${var.bucket_name}"

  tags = {
    Name     = "www Bucket for redirect to the main bucket"
    Endpoint = "http://www.${var.bucket_name}"
  }
}

resource "aws_s3_bucket_website_configuration" "redirect_bucket_website" {
  bucket = aws_s3_bucket.redirect_bucket.id

  redirect_all_requests_to {
    host_name = var.bucket_name
  }
}

resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_ownership_controls" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "access_reles" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl_rules" {
  depends_on = [
    aws_s3_bucket_ownership_controls.static_website,
    aws_s3_bucket_public_access_block.access_reles,
  ]
  bucket = aws_s3_bucket.static_website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${var.bucket_name}/*",
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "bucket_objects" {
  for_each = fileset("${path.module}/pages", "*")

  bucket = aws_s3_bucket.static_website.id
  key    = each.value
  source = "${path.module}/pages/${each.value}"
  content_type = lookup({
    "html" = "text/html",
  }, split(".", each.value)[1], "application/octet-stream")
}