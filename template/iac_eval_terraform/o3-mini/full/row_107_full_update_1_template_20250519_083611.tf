Below is the complete Terraform HCL program. In this configuration, we specify the AWS provider (using the us-east-1 region), create an S3 bucket named "sample" and then enable versioning on that bucket with the status set to "Enabled". The expected bucket owner is set to "123456789012" in the bucket versioning resource to maintain the ownership consistency.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "sample" {
  bucket = "sample"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "sample_versioning" {
  bucket = aws_s3_bucket.sample.id

  versioning_configuration {
    status = "Enabled"
  }

  expected_bucket_owner = "123456789012"
}
</iac_template>