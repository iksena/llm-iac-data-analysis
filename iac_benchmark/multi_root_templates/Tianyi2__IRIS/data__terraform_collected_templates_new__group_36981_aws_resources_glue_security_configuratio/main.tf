resource "aws_glue_security_configuration" "this" {
  name   = var.name
  region = var.region

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = var.cloudwatch_encryption_mode
      kms_key_arn                = var.cloudwatch_kms_key_arn
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = var.job_bookmarks_encryption_mode
      kms_key_arn                   = var.job_bookmarks_kms_key_arn
    }

    s3_encryption {
      s3_encryption_mode = var.s3_encryption_mode
      kms_key_arn        = var.s3_kms_key_arn
    }
  }
}