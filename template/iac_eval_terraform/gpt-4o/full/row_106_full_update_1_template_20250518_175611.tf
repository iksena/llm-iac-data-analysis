The Terraform program will create an AWS S3 bucket named 'test-bucket' with specific configurations to enhance security and prevent accidental deletion. The bucket will have private ACLs, ensuring that only the bucket owner has access. Server-side encryption will be enabled using AES256 to protect data at rest. Additionally, a public access block will be configured to restrict any public access to the bucket. The bucket will also have a lifecycle rule to prevent accidental destruction by requiring a confirmation before deletion.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket"

  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "test_bucket_public_access_block" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

</iac_template>