resource "aws_s3_bucket" "bootstrap" {
  bucket = "terraform-monorepo.online.ntnu.no"
}

resource "aws_s3_bucket_versioning" "bootstrap" {
  bucket = aws_s3_bucket.bootstrap.bucket

  versioning_configuration {
    status = "Enabled"
  }
}
