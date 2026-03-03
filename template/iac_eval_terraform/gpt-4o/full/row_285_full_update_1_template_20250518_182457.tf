To fulfill the business need, I will create a Terraform configuration that provisions an AWS S3 bucket configured to host a static website. The bucket will be set up with the necessary permissions to allow public access to the website content. The website will use "index.html" as the index page. Additionally, I will configure the AWS provider to deploy resources in a specified region.

Here is the Terraform HCL program:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "static_website" {
  bucket = "my-static-website-bucket-123456" # Ensure this bucket name is globally unique

  website {
    index_document = "index.html"
  }

  acl = "public-read"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-static-website-bucket-123456/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "index.html"
  source = "path/to/your/index.html" # Replace with the path to your local index.html file
  acl    = "public-read"
}
```
</iac_template>

This configuration includes:
- An AWS provider configured for the "us-east-1" region.
- An S3 bucket named "my-static-website-bucket-123456" (ensure the bucket name is unique).
- The bucket is configured to host a static website with "index.html" as the index document.
- A bucket policy that allows public read access to the objects within the bucket.
- An S3 bucket object resource to upload the "index.html" file to the bucket, making it publicly accessible.