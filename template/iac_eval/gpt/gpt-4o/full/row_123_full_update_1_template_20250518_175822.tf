The Terraform configuration will create an AWS S3 bucket with a specified name and configure its ownership controls. The ownership controls will be set to ensure that the object ownership is 'BucketOwnerPreferred'. This configuration will include the necessary provider setup for AWS and will ensure that the resources are properly linked using references.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name-12345"
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
```
</iac_template>