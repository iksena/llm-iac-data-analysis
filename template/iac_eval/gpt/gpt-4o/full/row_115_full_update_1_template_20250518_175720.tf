The Terraform program will create two AWS S3 buckets. The first bucket is for CloudGoat data storage, and its name will dynamically incorporate a suffix "test" from a variable. This bucket will have private ACLs and ownership controls set to ObjectWriter. The second bucket is for web data storage, also with a dynamic name. An object named 'order_data2.csv' will be uploaded to this web data bucket from a specified local file path. The web data bucket will have public access block settings configured to ignore public ACLs, block public ACLs, and restrict public buckets. Additionally, a bucket policy will be created to allow the 's3:PutObject' action for all principals on the web data bucket's objects.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

variable "bucket_suffix" {
  default = "test"
}

resource "aws_s3_bucket" "cloudgoat_data" {
  bucket = "cloudgoat-data-${var.bucket_suffix}"

  acl = "private"

  ownership_controls {
    rule {
      object_ownership = "ObjectWriter"
    }
  }
}

resource "aws_s3_bucket" "web_data" {
  bucket = "web-data-${var.bucket_suffix}"

  acl = "private"

  public_access_block {
    block_public_acls   = true
    ignore_public_acls  = true
    block_public_policy = true
    restrict_public_buckets = true
  }
}

resource "aws_s3_bucket_object" "order_data" {
  bucket = aws_s3_bucket.web_data.bucket
  key    = "order_data2.csv"
  source = "path/to/local/order_data2.csv"
}

resource "aws_s3_bucket_policy" "web_data_policy" {
  bucket = aws_s3_bucket.web_data.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.web_data.arn}/*"
      }
    ]
  })
}
```
</iac_template>