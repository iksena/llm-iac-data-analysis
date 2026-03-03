provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "source_bucket" {
  bucket = "my-source-bucket-123456"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "inventory_bucket" {
  bucket = "my-inventory-bucket-123456"
  acl    = "private"
}

resource "aws_iam_role" "inventory_role" {
  name = "s3-inventory-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "inventory_policy" {
  name        = "s3-inventory-policy"
  description = "Policy to allow S3 inventory to write to the destination bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.inventory_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "inventory_policy_attachment" {
  role       = aws_iam_role.inventory_role.name
  policy_arn = aws_iam_policy.inventory_policy.arn
}

resource "aws_s3_bucket_inventory" "inventory" {
  bucket = aws_s3_bucket.source_bucket.id
  name   = "weekly-inventory"

  destination {
    bucket {
      format = "CSV"
      bucket_arn = aws_s3_bucket.inventory_bucket.arn
      account_id = data.aws_caller_identity.current.account_id
      role_arn   = aws_iam_role.inventory_role.arn
    }
  }

  schedule {
    frequency = "Weekly"
  }

  included_object_versions = "Current"
}

data "aws_caller_identity" "current" {}