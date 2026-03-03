The Terraform configuration will define an AWS S3 bucket with a unique name "my_unique_bucket_name". It will set an ACL (Access Control List) for the bucket to make it private. Additionally, a bucket policy will be created to allow the `s3:GetObject` action for all principals, but only if the request includes a specific `aws:Referer` header. This setup is useful for controlling access to the bucket's objects based on the origin of the request.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-1234567890"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:Referer" = "http://example.com"
          }
        }
      }
    ]
  })
}
```
</iac_template>

This configuration includes:
- An AWS provider configured for the `us-east-1` region.
- An S3 bucket with a unique name and private ACL.
- A bucket policy that allows `s3:GetObject` actions for all principals, conditioned on the `aws:Referer` header being "http://example.com".