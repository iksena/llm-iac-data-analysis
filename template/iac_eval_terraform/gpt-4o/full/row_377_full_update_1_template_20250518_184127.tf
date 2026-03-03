To manage an AWS Lightsail Distribution with an S3 bucket as the origin, we will create a Terraform configuration that sets up an S3 bucket to store content and a Lightsail Distribution to serve that content. The configuration will include the necessary IAM roles and policies to allow the Lightsail Distribution to access the S3 bucket. We will also configure the AWS provider to deploy resources in a specified region.

The Terraform program will:
1. Create an S3 bucket to store the content.
2. Set up an IAM policy and role to allow the Lightsail Distribution to access the S3 bucket.
3. Create a Lightsail Distribution with the S3 bucket as the origin.
4. Configure the AWS provider.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "content_bucket" {
  bucket = "my-lightsail-content-bucket"
  acl    = "private"
}

resource "aws_iam_role" "lightsail_access_role" {
  name = "LightsailAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lightsail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lightsail_s3_access_policy" {
  name        = "LightsailS3AccessPolicy"
  description = "Policy to allow Lightsail Distribution to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.content_bucket.arn,
          "${aws_s3_bucket.content_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lightsail_access_role.name
  policy_arn = aws_iam_policy.lightsail_s3_access_policy.arn
}

resource "aws_lightsail_distribution" "my_distribution" {
  name = "my-lightsail-distribution"

  origin {
    name = aws_s3_bucket.content_bucket.bucket
    protocol_policy = "https-only"
  }

  default_cache_behavior {
    behavior = "cache"
  }
}
```
</iac_template>

This configuration sets up an S3 bucket, an IAM role with a policy to allow access to the bucket, and a Lightsail Distribution that uses the S3 bucket as its origin. The AWS provider is configured to use the "us-east-1" region.