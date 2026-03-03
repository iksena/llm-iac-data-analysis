To address the business need, we will create two AWS S3 buckets using Terraform. The first bucket will be used to store objects, and the second bucket will be used to store the CSV inventory reports. We will configure an S3 Inventory configuration on the first bucket to generate a weekly CSV report of all current object versions. This report will be stored in the second bucket. We will also set up the necessary IAM roles and policies to allow the inventory process to write to the destination bucket.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "source_bucket" {
  bucket = "my-source-bucket-123456"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "inventory_bucket" {
  bucket = "my-inventory-bucket-123456"
  acl    = "private"
}

resource "aws_iam_role" "inventory_role" {
  name = "s3-inventory-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "inventory_policy" {
  name        = "s3-inventory-policy"
  description = "Policy to allow S3 inventory to write to the destination bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.inventory_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "inventory_policy_attachment" {
  role       = aws_iam_role.inventory_role.name
  policy_arn = aws_iam_policy.inventory_policy.arn
}

resource "aws_s3_bucket_inventory" "inventory" {
  bucket = aws_s3_bucket.source_bucket.id
  name   = "weekly-inventory"

  destination {
    bucket {
      format = "CSV"
      bucket_arn = aws_s3_bucket.inventory_bucket.arn
      account_id = data.aws_caller_identity.current.account_id
      role_arn   = aws_iam_role.inventory_role.arn
    }
  }

  schedule {
    frequency = "Weekly"
  }

  included_object_versions = "Current"
}

data "aws_caller_identity" "current" {}
```
</iac_template>

This configuration sets up two S3 buckets, an IAM role with the necessary permissions, and an S3 inventory configuration to generate weekly CSV reports of current object versions. The reports are stored in the second bucket.