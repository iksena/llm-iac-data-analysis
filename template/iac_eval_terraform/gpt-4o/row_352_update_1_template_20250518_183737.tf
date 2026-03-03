provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "rds_audit_role" {
  name = "rds-audit-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "rds_audit_policy" {
  name = "rds-audit-policy"
  role = aws_iam_role.rds_audit_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = "${aws_s3_bucket.audit_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket" "audit_bucket" {
  bucket = "rds-audit-logs-bucket"
  acl    = "private"
}

resource "aws_db_option_group" "option_group_pike" {
  name                     = "option-group-pike"
  engine_name              = "sqlserver-ee"
  major_engine_version     = "11.00"

  option {
    option_name = "SQLSERVER_AUDIT"

    option_settings {
      name  = "IAM_ROLE_ARN"
      value = aws_iam_role.rds_audit_role.arn
    }

    option_settings {
      name  = "S3_BUCKET_ARN"
      value = aws_s3_bucket.audit_bucket.arn
    }
  }

  option {
    option_name = "TDE"
  }
}