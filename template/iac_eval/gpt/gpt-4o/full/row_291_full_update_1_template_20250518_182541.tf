The Terraform program will create an AWS S3 bucket with versioning explicitly disabled. The configuration will include the necessary provider setup for AWS, specifying a region. The S3 bucket will be created with a unique name, and versioning will be set to "Disabled" to ensure that no versioning is applied to the objects stored in the bucket.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-123456"

  versioning {
    enabled = false
  }
}
```
</iac_template>