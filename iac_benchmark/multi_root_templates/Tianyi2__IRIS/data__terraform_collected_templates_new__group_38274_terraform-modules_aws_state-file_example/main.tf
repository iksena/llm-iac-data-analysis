module "example" {
  source                  = "../.."
  iam_principals          = [aws_iam_user.example.arn]
  state_bucket_kms_key_id = aws_kms_key.example.arn
  region_name             = data.aws_region.current.name
}

resource "aws_iam_user" "example" {
  #checkov:skip=CKV_AWS_273:Example resource. Not used.
  name = "example"
}

resource "aws_kms_key" "example" {
  #checkov:skip=CKV_AWS_273:Example resource. Not used.
  description             = "Key used to encrypt both the state and logs buckets"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_key_policy" "example" {
  key_id = aws_kms_key.example.id
  policy = jsonencode({
    Id = "example"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.example.arn
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow Logs Service to use the key"
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:*"
        ]
        Resource = "*"
      }
    ]
    Version = "2012-10-17"
  })
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}