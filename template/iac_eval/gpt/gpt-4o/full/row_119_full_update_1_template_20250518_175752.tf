The Terraform configuration will set up an AWS environment with a Key Management Service (KMS) key and an S3 bucket. The KMS key will have a specific description and a deletion window set in days. The S3 bucket will be created with a specified name, and server-side encryption will be configured using the KMS key. The encryption will utilize the AWS KMS algorithm to ensure data security. The configuration will include all necessary resource blocks and references to ensure proper setup and integration between the KMS key and the S3 bucket.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "my_kms_key" {
  description         = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 30
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-123456"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.my_kms_key.arn
    }
  }
}
```
</iac_template>