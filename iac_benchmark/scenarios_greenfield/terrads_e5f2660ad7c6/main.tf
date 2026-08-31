resource "aws_s3_bucket" "backend" {
  bucket = lower(join("-", [var.common_tags.Company, var.common_tags.Service, var.common_tags.Environment, "tfstate"]))

  tags = merge(
    var.common_tags,
    {
      Type = "s3"
      Name = join("-", [
        var.common_tags.Company,
        var.common_tags.Service,
        var.common_tags.Environment,
      "tfstate"])
    }
  )
}

resource "aws_s3_bucket_ownership_controls" "backend" {
  bucket = aws_s3_bucket.backend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "backend" {
  bucket     = aws_s3_bucket.backend.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.backend]
}

resource "aws_s3_bucket_versioning" "backend" {
  bucket = aws_s3_bucket.backend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.bucket_sse_algorithm
    }
  }
}
resource "aws_s3_bucket_public_access_block" "backend" {
  bucket = aws_s3_bucket.backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "lock" {
  name           = join("-", [var.common_tags.Company, var.common_tags.Service, var.common_tags.Environment, "tflock", "ddb"])
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  tags = merge(
    var.common_tags,
    {
      Type = "dynamodb"
      Name = join("-", [
        var.common_tags.Company,
        var.common_tags.Service,
        var.common_tags.Environment,
      "tflock", "ddb"])
    }
  )
  attribute {
    name = "LockID"
    type = "S"
  }
}
