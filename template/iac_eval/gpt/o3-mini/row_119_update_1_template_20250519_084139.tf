terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "kms_key_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "KMS key for S3 bucket encryption"
}

variable "kms_deletion_window_days" {
  description = "Number of days to wait before KMS key is deleted"
  type        = number
  default     = 10
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to be created"
  type        = string
  default     = "my-terraform-s3-bucket-unique-name-123456"
}

resource "aws_kms_key" "s3_key" {
  description              = var.kms_key_description
  deletion_window_in_days  = var.kms_deletion_window_days
  enable_key_rotation      = true
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name

  # Optional: You can add additional bucket settings here as needed.
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
  }
}