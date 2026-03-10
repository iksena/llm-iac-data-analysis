# ── variables.tf ────────────────────────────────────
variable "region" {
  description = "The AWS region to launch the resources."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "valerii-vasianovych.online"
}

variable "acl" {
  description = "The ACL for the S3 bucket."
  type        = string
  default     = "public-read"
}

variable "path_pages" {
  description = "The path to the static files to be uploaded to the S3 bucket."
  type        = string
  default     = "pages"
}

variable "zone_id" {
  description = "The Route 53 zone ID."
  type        = string
  default     = "Z3AQBSTGFYJSTF"
}

# ── datasource.tf ────────────────────────────────────
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_route53_zone" "selected" {
  name         = var.bucket_name
  private_zone = false
}

# ── output.tf ────────────────────────────────────
output "region" {
  value = data.aws_region.current.name
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "bucket_name" {
  value = aws_s3_bucket.static_website.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.static_website.arn
}

output "bucket_website_domain" {
  value = "http://${var.bucket_name}"
}

output "bucket_website_domain_www" {
  value = "http://www.${var.bucket_name}"
}



# ── provider.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/s3-static-page/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16"
    }
  }
}

# ── route53.tf ────────────────────────────────────
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.bucket_name
  type    = "A"
  alias {
    name                   = "s3-website-${var.region}.amazonaws.com."
    zone_id                = var.zone_id
    evaluate_target_health = false
  }
  depends_on = [aws_s3_bucket.static_website]
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${var.bucket_name}"
  type    = "A"
  alias {
    name                   = "s3-website-${var.region}.amazonaws.com."
    zone_id                = var.zone_id
    evaluate_target_health = false
  }
  depends_on = [aws_s3_bucket.redirect_bucket]
}


# ── static-s3.tf ────────────────────────────────────
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