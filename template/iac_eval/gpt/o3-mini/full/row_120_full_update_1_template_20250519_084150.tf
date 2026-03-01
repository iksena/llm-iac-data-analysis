Below is the description of the Terraform program that will be defined:

1. The program uses the AWS provider configured to a default region (us-east-1). A variable is declared for the S3 bucket name with a default value.
2. An S3 bucket resource is created using the specified bucket name.
3. Next, the program creates an S3 bucket ownership controls resource. This resource references the bucket created earlier through its ID and sets the object ownership to a predefined value ("BucketOwnerPreferred").
4. Finally, an S3 bucket ACL resource is defined. It references the same bucket (via its ID) and sets the access control list to private. This ACL resource is set to depend on the ownership controls resource to ensure proper order of application.

Below is the complete Terraform HCL configuration wrapped within the <iac_template> tags:

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "my-unique-s3-bucket"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.ownership
  ]
}
</iac_template>