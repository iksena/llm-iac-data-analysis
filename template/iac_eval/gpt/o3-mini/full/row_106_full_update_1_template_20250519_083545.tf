Below is the description of the Terraform program followed by the complete HCL code.

Description:
This Terraform configuration deploys an AWS S3 bucket named "test-bucket". The bucket is configured with a private access control list ("private") and includes a server-side encryption configuration that uses AES256 encryption (using a nested block within the resource). Lifecycle settings prevent accidental destruction by setting "prevent_destroy = true". In addition, the configuration creates a corresponding public access block resource ensuring that no public access is allowed to this S3 bucket. The AWS provider is configured with the default region "us-east-1", and no undeclared resources or variables are referenced.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "test_bucket_public_access" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
</iac_template>