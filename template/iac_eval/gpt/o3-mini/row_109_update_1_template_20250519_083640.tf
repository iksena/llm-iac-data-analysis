provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "infra_bucket" {
  bucket = "wellcomecollection-platform-infra"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  lifecycle_rule {
    id      = "delete_tmp_objects"
    prefix  = "tmp/"
    enabled = true

    expiration {
      days = 30
    }
  }

  lifecycle_rule {
    id      = "transition_and_expire_old_versions"
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