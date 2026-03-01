Description:
This Terraform program creates an AWS S3 bucket named "example-bucket". The bucket is configured with versioning enabled (a requirement for using S3 Object Lock) and object lock enabled. The object lock configuration uses governance mode to retain objects for 90 days once set. The configuration also includes an AWS provider setup with a default region.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"

  versioning {
    enabled = true
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"

    rule {
      default_retention {
        mode = "GOVERNANCE"
        days = 90
      }
    }
  }
}
</iac_template>