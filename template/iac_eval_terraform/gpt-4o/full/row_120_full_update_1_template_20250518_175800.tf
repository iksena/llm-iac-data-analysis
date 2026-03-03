The Terraform configuration will create an AWS S3 bucket with a specified name. It will then configure the bucket's ownership controls to enforce a specific object ownership policy. Following this, an S3 bucket ACL will be defined to set the bucket's access to private. The configuration will ensure that the ACL is applied only after the ownership controls have been successfully set. Each resource will be properly referenced and connected to ensure a seamless deployment.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name-12345"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.example]
}
```
</iac_template>