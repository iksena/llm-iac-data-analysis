Description:
This Terraform configuration creates an AWS S3 bucket named "mybucket" with versioning enabled and object lock retention configured for compliance mode with a retention period of 5 days. The bucket is created with object lock enabled at creation time, and the object_lock_configuration block is used to enforce the compliance mode retention policy. Additionally, outputs are provided leveraging dynamic references to the bucket’s ID and ARN.

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mybucket" {
  bucket               = "mybucket"
  acl                  = "private"
  force_destroy        = false
  object_lock_enabled  = true

  versioning {
    enabled = true
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"

    rule {
      default_retention {
        mode = "COMPLIANCE"
        days = 5
      }
    }
  }
}

output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.mybucket.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.mybucket.arn
}
</iac_template>