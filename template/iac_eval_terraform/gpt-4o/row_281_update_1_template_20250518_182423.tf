provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "s3_encryption_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "s3_encryption_key_alias" {
  name          = "alias/s3EncryptionKey"
  target_key_id = aws_kms_key.s3_encryption_key.id
}

resource "aws_s3_bucket" "my_secure_bucket" {
  bucket = "my-secure-bucket-123456"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3_encryption_key.arn
      }
    }
  }
}

resource "aws_iam_role" "s3_kms_role" {
  name = "s3-kms-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_kms_policy" {
  name = "s3-kms-access-policy"
  role = aws_iam_role.s3_kms_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.s3_encryption_key.arn
      }
    ]
  })
}