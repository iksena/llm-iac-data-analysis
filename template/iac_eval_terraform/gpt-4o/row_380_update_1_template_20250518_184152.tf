provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "long_term_storage" {
  bucket = "my-long-term-storage-bucket"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 3650
    }

    noncurrent_version_expiration {
      days = 3650
    }
  }
}

output "bucket_name" {
  value = aws_s3_bucket.long_term_storage.bucket
}