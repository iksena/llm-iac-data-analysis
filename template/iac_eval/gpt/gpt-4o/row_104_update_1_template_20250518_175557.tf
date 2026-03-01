provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my_bucket"
}

resource "aws_s3_bucket_policy" "deny_specific_ip" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "DenyAccessFromSpecificIP"
    Statement = [
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "arn:aws:s3:::my_bucket",
          "arn:aws:s3:::my_bucket/*"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "192.0.2.0/24"
          }
        }
      }
    ]
  })
}