To set up an AWS S3 bucket and DynamoDB table for Terraform state management, we will create an S3 bucket with versioning enabled, server-side encryption using AES256, and public access restrictions to prevent unauthorized access. The bucket will also have a policy to prevent accidental deletion. Additionally, we will create a DynamoDB table with a hash key named 'LockID' and use the 'PAY_PER_REQUEST' billing mode to handle Terraform state locking. This configuration will ensure that the Terraform state is securely stored and managed.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"

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

  lifecycle {
    prevent_destroy = true
  }

  block_public_access {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_policy" "terraform_state_policy" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Principal = "*"
        Action = "s3:DeleteBucket"
        Resource = aws_s3_bucket.terraform_state.arn
      }
    ]
  })
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```
</iac_template>