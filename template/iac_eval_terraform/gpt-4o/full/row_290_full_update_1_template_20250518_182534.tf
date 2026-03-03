The Terraform program will create an AWS S3 bucket with versioning enabled. This setup is useful for maintaining different versions of objects stored in the bucket, which can be critical for data recovery and auditing purposes. The program will include the necessary provider configuration for AWS and define the S3 bucket resource along with the versioning configuration.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-terraform-12345"
  acl    = "private"

  tags = {
    Name        = "ExampleBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}
```
</iac_template>