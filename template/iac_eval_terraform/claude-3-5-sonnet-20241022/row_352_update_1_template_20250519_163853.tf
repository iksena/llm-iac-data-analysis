provider "aws" {
  region = "us-east-1"
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 bucket for audit logs
resource "aws_s3_bucket" "audit_logs" {
  bucket = "sqlserver-audit-logs-${random_string.suffix.result}"
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM role for SQL Server Audit
resource "aws_iam_role" "sqlserver_audit" {
  name = "sqlserver-audit-role-${random_string.suffix.result}"

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

# IAM policy for SQL Server Audit
resource "aws_iam_role_policy" "sqlserver_audit" {
  name = "sqlserver-audit-policy"
  role = aws_iam_role.sqlserver_audit.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.audit_logs.arn,
          "${aws_s3_bucket.audit_logs.arn}/*"
        ]
      }
    ]
  })
}

# RDS Option Group
resource "aws_db_option_group" "pike" {
  name                     = "option-group-pike"
  option_group_description = "Option group for SQL Server Enterprise Edition with Audit and TDE"
  engine_name             = "sqlserver-ee"
  major_engine_version    = "11.00"

  option {
    option_name = "SQLSERVER_AUDIT"
    option_settings {
      name  = "IAM_ROLE_ARN"
      value = aws_iam_role.sqlserver_audit.arn
    }
    option_settings {
      name  = "S3_BUCKET_ARN"
      value = aws_s3_bucket.audit_logs.arn
    }
  }

  option {
    option_name = "TDE"
  }

  tags = {
    Name = "option-group-pike"
    Environment = "production"
  }
}