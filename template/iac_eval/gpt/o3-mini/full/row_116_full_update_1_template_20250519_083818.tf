Description:
This Terraform configuration deploys an AWS S3 bucket with a unique name (“my_unique_bucket_name”). The bucket is assigned an ACL setting (set to "private" in this example) and a bucket policy is attached that allows all principals the s3:GetObject action; however, this permission is conditioned on the HTTP Referer header matching a specific pattern (in this case "http://example.com/*"). The provider is configured for the us-east-1 region, and all required resources and variables are fully declared.

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my_unique_bucket_name"
  acl    = "private"

  tags = {
    Name = "my_unique_bucket_name"
  }
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid       = "AllowGetObjectWithRefererCondition"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.my_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:Referer"
      values   = ["http://example.com/*"]
    }
  }
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}
</iac_template>