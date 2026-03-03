The Terraform program will create an AWS S3 bucket named 'wellcomecollection-platform-infra' with preventive destruction measures by enabling versioning. The bucket will have an ACL set to 'private' to ensure that the contents are not publicly accessible. A lifecycle policy will be configured to automatically delete objects with a 'tmp/' prefix after 30 days. Additionally, the program will implement versioning on the bucket and set up lifecycle rules to transition old versions to the 'STANDARD_IA' storage class after 30 days and delete noncurrent versions after 90 days.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "wellcomecollection_platform_infra" {
  bucket = "wellcomecollection-platform-infra"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "tmp-folder-deletion"
    enabled = true

    prefix = "tmp/"

    expiration {
      days = 30
    }
  }

  lifecycle_rule {
    id      = "versioning-lifecycle"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
}
```
</iac_template>