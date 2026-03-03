The Terraform program will create an AWS S3 bucket and configure a public access block for the bucket to manage its public access settings. The public access block will ensure that the bucket's public access is restricted according to the specified settings. The configuration will use the AWS provider and will be set in the "us-east-1" region. The S3 bucket will have a unique name, and the public access block will be configured to block public ACLs and block public policy.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-unique-bucket-name-12345"
  acl    = "private"

  tags = {
    Name        = "ExampleBucket"
    Environment = "Dev"
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

This configuration will create an S3 bucket with a unique name and apply a public access block to ensure that the bucket's public access is restricted. The public access block settings will block public ACLs and policies, ignore public ACLs, and restrict public buckets.