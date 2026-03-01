provider "aws" {
  region = "us-east-1"
}

# Create RDS Option Group
resource "aws_db_option_group" "pike" {
  name                     = "option-group-pike"
  option_group_description = "Option group for SQL Server Enterprise Edition with Audit and TDE"
  engine_name             = "sqlserver-ee"
  major_engine_version    = "11.00"

  option {
    option_name = "SQLSERVER_AUDIT"
    
    option_settings {
      name  = "ENABLE_COMPRESSION"
      value = "false"
    }
    
    option_settings {
      name  = "S3_BUCKET_ARN"
      value = "arn:aws:s3:::rds-audit-logs-${data.aws_caller_identity.current.account_id}"
    }
  }

  option {
    option_name = "TDE"
  }

  tags = {
    Name = "option-group-pike"
    Environment = "Production"
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create IAM role for SQL Server Audit
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

# Create S3 bucket for audit logs
resource "aws_s3_bucket" "audit_logs" {
  bucket = "rds-audit-logs-${data.aws_caller_identity.current.account_id}"
}

# Create S3 bucket policy
resource "aws_s3_bucket_policy" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowRDSAuditAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.rds_audit_role.arn
        }
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

# Attach policy to IAM role
resource "aws_iam_role_policy" "rds_audit_policy" {
  name = "rds-audit-policy"
  role = aws_iam_role.rds_audit_role.id

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