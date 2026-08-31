resource "aws_s3_bucket" "s3_bucket" {  
  bucket = "airflow-centricity-${var.environment}"
  versioning {
    enabled = true
  }

  tags = merge(local.tags, {
    Environment = var.environment
  })
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {  
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "dags" {  
  for_each = fileset("dags/", "*.py")
  bucket   = aws_s3_bucket.s3_bucket.id
  key      = "dags/${each.value}"
  source   = "dags/${each.value}"
  etag     = filemd5("dags/${each.value}")
}

resource "aws_s3_bucket" "centricity" {  
  count = var.create_buckets ? length(var.bucket_unique_ids) : 0 
  bucket        = var.bucket_unique_ids[count.index]
  force_destroy = var.force_destroy

  tags = merge(local.tags, {
    Environment = var.environment
  })
}

resource "aws_s3_bucket_public_access_block" "centricity" {  
  depends_on              = [aws_s3_bucket.centricity]
  count                   = var.create_buckets ? length(var.bucket_unique_ids) : 0
  bucket                  = var.bucket_unique_ids[count.index]
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
