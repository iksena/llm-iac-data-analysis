The Terraform program will create an AWS S3 bucket and configure a CORS (Cross-Origin Resource Sharing) policy for it. The CORS configuration will include a rule that specifies allowed origins, allowed methods, allowed headers, and expose headers. This setup is useful for enabling web applications hosted on different domains to interact with the S3 bucket.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-s3-bucket-terraform"
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["http://example.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
```
</iac_template>

This configuration sets up an S3 bucket named "example-s3-bucket-terraform" with a CORS rule that allows GET, PUT, and POST methods from "http://example.com". It allows all headers and exposes the "ETag" header, with a max age of 3000 seconds for preflight requests.