The Terraform program will create an AWS S3 bucket named "sample" with versioning enabled. This configuration will ensure that all changes to objects in the bucket are versioned, allowing for recovery of previous versions if needed. Additionally, the configuration will specify the expected bucket owner to be '123456789012' to ensure that the bucket is accessed and managed by the correct AWS account. The program will include the necessary provider configuration for AWS.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "sample" {
  bucket = "sample"

  versioning {
    enabled = true
  }

  expected_bucket_owner = "123456789012"
}
```
</iac_template>