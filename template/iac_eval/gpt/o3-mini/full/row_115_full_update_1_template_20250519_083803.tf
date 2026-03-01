Description:
This Terraform program deploys two AWS S3 buckets and an object upload. The first bucket is for CloudGoat data storage and is named dynamically using a variable "bucket_suffix" (default is "test"). It is configured with a private ACL and an S3 ownership control policy set for ObjectWriter access using the aws_s3_bucket_ownership_controls resource. The second bucket is for web data storage with a similar dynamic name. It includes public access block settings that ignore and block public ACLs and restrict public buckets. An object ("order_data2.csv") is uploaded into the web data bucket from a local file path. In addition, a bucket policy is attached to the web data bucket to allow the s3:PutObject action for all principals on its objects. The configuration includes a valid AWS provider with region set to "us-east-1" and all required resources are declared, making this configuration deployable.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

variable "bucket_suffix" {
  description = "Suffix to append to bucket names"
  type        = string
  default     = "test"
}

# CloudGoat data bucket for private data storage with Ownership Controls
resource "aws_s3_bucket" "cloudgoat_bucket" {
  bucket = "cloudgoat-${var.bucket_suffix}"
  acl    = "private"

  tags = {
    Name = "CloudGoat Data Bucket"
  }
}

# Ownership controls for CloudGoat bucket
resource "aws_s3_bucket_ownership_controls" "cloudgoat_ownership" {
  bucket = aws_s3_bucket.cloudgoat_bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

# Web data storage bucket
resource "aws_s3_bucket" "webdata_bucket" {
  bucket = "webdata-${var.bucket_suffix}"
  acl    = "private"

  tags = {
    Name = "Web Data Bucket"
  }
}

# Public Access Block settings for web data bucket
resource "aws_s3_bucket_public_access_block" "webdata_public_access" {
  bucket                  = aws_s3_bucket.webdata_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload local file order_data2.csv into webdata bucket
resource "aws_s3_object" "order_data_upload" {
  bucket = aws_s3_bucket.webdata_bucket.id
  key    = "order_data2.csv"
  source = "order_data2.csv"
  etag   = filemd5("order_data2.csv")
}

# Bucket policy for web data bucket to allow s3:PutObject action for all principals
data "aws_iam_policy_document" "webdata_policy_doc" {
  statement {
    sid    = "AllowPutObjectForAll"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.webdata_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "webdata_policy" {
  bucket = aws_s3_bucket.webdata_bucket.id
  policy = data.aws_iam_policy_document.webdata_policy_doc.json
}
</iac_template>