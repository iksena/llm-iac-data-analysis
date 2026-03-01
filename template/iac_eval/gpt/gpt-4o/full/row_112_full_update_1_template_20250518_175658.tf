To meet the business requirement, we will create an AWS S3 bucket named 'example-bucket' with object lock enabled. The object lock will be configured in compliance mode with a retention period of 30 days. This setup ensures that objects stored in the bucket cannot be deleted or overwritten for the specified retention period, providing an additional layer of data protection. We will use the AWS provider to manage the resources in the 'us-east-1' region.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"

  versioning {
    enabled = true
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"

    rule {
      default_retention {
        mode  = "COMPLIANCE"
        days  = 30
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```
</iac_template>

This configuration includes:
- An S3 bucket named 'example-bucket' with versioning enabled, which is a prerequisite for enabling object lock.
- Object lock configuration set to compliance mode with a retention period of 30 days.
- A public access block to ensure the bucket is not publicly accessible.