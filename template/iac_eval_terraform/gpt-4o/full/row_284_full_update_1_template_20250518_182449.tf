The Terraform program will create an AWS S3 bucket configured to host a static website. The configuration will include setting up the bucket with the necessary permissions and enabling website hosting. The bucket will have a default index document and an error document specified for the website configuration. An IAM role will be created to allow public read access to the bucket contents, which is necessary for a static website.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "example-website-bucket-12345"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

output "website_endpoint" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}
```
</iac_template>

This configuration sets up an S3 bucket with public read access, enabling it to serve as a static website. The bucket policy allows anyone to read the objects in the bucket, which is necessary for a public website. The output provides the website endpoint URL.