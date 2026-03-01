To address the business need for long-term data storage and backup on AWS, we will create an Amazon S3 bucket. This bucket will be configured with versioning to preserve, retrieve, and restore every version of every object stored in it, which is crucial for backup purposes. Additionally, we will enable server-side encryption to ensure data security. The bucket will also have a lifecycle policy to transition objects to the S3 Glacier storage class for cost-effective long-term storage after a specified period.

Here is the Terraform HCL configuration for this setup:

<iac_template>
```hcl
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
```
</iac_template>

This configuration will create an S3 bucket with versioning and server-side encryption enabled. It includes a lifecycle rule to transition objects to the Glacier storage class after 30 days and to expire objects after 10 years (3650 days). The bucket name is outputted for reference.