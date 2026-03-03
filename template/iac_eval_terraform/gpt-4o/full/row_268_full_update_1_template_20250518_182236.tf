To store images for your website, we will create an Amazon S3 bucket. This bucket will be configured to store your images securely and will be publicly accessible so that the images can be displayed on your website. We will also set up the necessary IAM roles and policies to ensure that the bucket is accessible only as needed. The bucket will be created in the `us-east-1` region.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website_images" {
  bucket = "my-website-images-bucket-12345"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "WebsiteImagesBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_policy" "website_images_policy" {
  bucket = aws_s3_bucket.website_images.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_images.arn}/*"
      }
    ]
  })
}
```

</iac_template>

This configuration creates an S3 bucket with public read access, allowing anyone to view the images stored in the bucket. The bucket policy is set to allow public access to the objects within the bucket. The bucket is tagged for easy identification and management.