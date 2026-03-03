Description:
This Terraform configuration creates an AWS S3 bucket with the name "pike-680235478471" and then applies public access block settings on the bucket to block public ACLs, block public policies, and restrict public buckets. The configuration uses the AWS provider in the "us-east-1" region (configurable via an input variable if needed). All necessary resources are created and referenced directly, ensuring a deployable configuration.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "pike-680235478471"
  acl    = "private"
  
  tags = {
    Name = "pike-680235478471"
  }
}

resource "aws_s3_bucket_public_access_block" "block_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
</iac_template>