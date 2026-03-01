Description:
This Terraform configuration creates an AWS S3 bucket named "wellcomecollection-platform-infra" with several preventive and lifecycle measures. The bucket ACL is set to "private" and deletion of the bucket is prevented using Terraform's lifecycle "prevent_destroy" setting. Bucket versioning is enabled. Two lifecycle rules are defined:
1. A rule to automatically delete any objects with a "tmp/" prefix after 30 days.
2. A rule that applies to versioned objects: it transitions noncurrent versions to the STANDARD_IA storage class after 30 days and deletes noncurrent versions after 90 days.
The configuration includes a provider block for AWS in a valid region.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "infra_bucket" {
  bucket = "wellcomecollection-platform-infra"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  lifecycle_rule {
    id      = "delete_tmp_objects"
    prefix  = "tmp/"
    enabled = true

    expiration {
      days = 30
    }
  }

  lifecycle_rule {
    id      = "transition_and_expire_old_versions"
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
</iac_template>