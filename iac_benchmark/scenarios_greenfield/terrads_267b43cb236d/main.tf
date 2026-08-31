terraform {
}

provider "aws" {
  region  = var.aws_region
}

provider "archive" {

}

resource "aws_s3_bucket" "raw_bucket" {
  bucket_prefix = "${var.env_name}-raw-bucket"
}

resource "aws_s3_bucket_public_access_block" "raw_bucket" {
  bucket = aws_s3_bucket.raw_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "raw_bucket_encryption" {
  bucket = aws_s3_bucket.raw_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Glue Job resources
resource "aws_s3_bucket" "glue_bucket" {
  bucket_prefix = "aws-glue-scripts-${var.env_name}-"
}

resource "aws_s3_bucket_public_access_block" "glue_bucket" {
  bucket = aws_s3_bucket.glue_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "glue_bucket_encryption" {
  bucket = aws_s3_bucket.glue_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_iam_role" "iam_role_for_glue" {
  name                = "${var.env_name}-glue-iam-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"]
  inline_policy {
    name = "${var.env_name}-s3-access-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = ["s3:*"]
          Effect = "Allow"
          Resource = [
            "${aws_s3_bucket.raw_bucket.arn}/*",
            "${aws_s3_bucket.raw_bucket.arn}"
          ]
        },
        {
          Action = ["s3:*"]
          Effect = "Allow"
          Resource = [
            "${aws_s3_bucket.glue_bucket.arn}/*",
            "${aws_s3_bucket.glue_bucket.arn}"
          ]
        }
      ]
    })
  }
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_s3_object" "glue_script_location" {
  key                    = "Scripts/glue_script"
  bucket                 = aws_s3_bucket.glue_bucket.id
  source                 = "glue-scripts/script.py"
  server_side_encryption = "AES256"
}

resource "aws_glue_job" "basic_glue_job" {
  name        = "${var.env_name}-basic-job"
  role_arn    = aws_iam_role.iam_role_for_glue.arn
  max_retries = "1"
  command {
    script_location = "s3://${aws_s3_bucket.glue_bucket.id}/${aws_s3_object.glue_script_location.key}"
  }
  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
}