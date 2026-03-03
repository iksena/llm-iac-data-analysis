provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "wellcomecollection_platform_infra" {
  bucket = "wellcomecollection-platform-infra"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "tmp-folder-deletion"
    enabled = true

    prefix = "tmp/"

    expiration {
      days = 30
    }
  }

  lifecycle_rule {
    id      = "versioning-lifecycle"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
}