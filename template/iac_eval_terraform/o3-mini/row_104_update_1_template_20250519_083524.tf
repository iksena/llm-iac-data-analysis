provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my_bucket"
}

variable "denied_ip" {
  description = "IP address to deny access from (in CIDR notation)"
  type        = string
  default     = "203.0.113.0/32"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Id        = "DenyIPPolicy"
    Statement = [
      {
        Sid       = "DenyIPAddress"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = var.denied_ip
          }
        }
      }
    ]
  })
}