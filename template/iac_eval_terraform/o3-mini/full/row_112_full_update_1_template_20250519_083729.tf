The following Terraform configuration creates an AWS S3 bucket named "example-bucket" with object lock enabled. It also configures the bucket with an object lock compliance mode retention rule that ensures newly added objects are automatically protected for 30 days.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"

  object_lock_configuration {
    object_lock_enabled = "Enabled"

    rule {
      default_retention {
        mode = "COMPLIANCE"
        days = 30
      }
    }
  }
}
</iac_template>