# ── awscc_s3_bucket_name_conditional.tf ────────────────────────────────────
# create s3 bucket with Terraform AWSCC, if the var name_length is bigger than 0, then use random pet for bucket name, otherwise set bucket name as var bucket_name
resource "awscc_s3_bucket" "example" {
  bucket_name = var.name_length > 0 ? random_pet.example.id : var.bucket_name
}

variable "bucket_name" {
  type    = string
  default = ""
}

variable "name_length" {
  type    = number
  default = 2
}

resource "random_pet" "example" {
  keepers = {
    length = var.name_length
  }
  length = var.name_length
}

# ── awscc_s3_bucket_name_dynamic.tf ────────────────────────────────────
# aws_iam_policy_document for bucket policy, use dynamic block to iterate over list of iam role names. For each statement, set the action to Getobject, set resource to bucket prefix + role name, set AWS principal role ARN with combination of account id and role name 

resource "awscc_s3_bucket" "example" {
}

resource "awscc_s3_bucket_policy" "example" {
  bucket          = awscc_s3_bucket.example.id
  policy_document = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "example" {
  dynamic "statement" {
    for_each = var.iam_role_names
    content {
      sid       = statement.key
      actions   = ["s3:GetObject"]
      resources = ["${awscc_s3_bucket.example.arn}/${statement.value}/*"]
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.account_id}:role/${statement.value}"]
      }
    }
  }
}

variable "iam_role_names" {
  type = list(any)
  default = [
    "my-role-1",
    "my-role-2"
  ]
}

variable "account_id" {
  type = string
}

# ── awscc_s3_bucket_p1.tf ────────────────────────────────────
# Create an S3 Bucket named 'example' via 'awscc' provider

resource "awscc_s3_bucket" "example" {
  // (Optional) Desired bucket name - must be globally unique value. If not specified,
  // AWS CloudFormation will generate a unique ID and use that for the bucket name
  bucket_name = "example"

  // (Optional) Enforce restrctions on public access for the bucket
  public_access_block_configuration = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

}


# ── awscc_s3_bucket_p2.tf ────────────────────────────────────
# Terraform code to create an S3 Bucket named 'example' via 'awscc' provider

resource "awscc_s3_bucket" "example" {
  // (Optional) Desired bucket name - must be globally unique value. If not specified,
  // AWS CloudFormation will generate a unique ID and use that for the bucket name
  bucket_name = "example"

  // (Optional) Enforce restrctions on public access for the bucket
  public_access_block_configuration = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

}


# ── awscc_s3_bucket_p3.tf ────────────────────────────────────
# Write Terraform configuration that creates S3 bucket named 'example', use awscc provider

resource "awscc_s3_bucket" "example" {
  // (Optional) Desired bucket name - must be globally unique value. If not specified,
  // AWS CloudFormation will generate a unique ID and use that for the bucket name
  bucket_name = "example"

  // (Optional) Enforce restrctions on public access for the bucket
  public_access_block_configuration = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

}
