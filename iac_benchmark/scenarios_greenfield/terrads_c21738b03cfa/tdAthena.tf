resource "aws_athena_database" "database_gold" {
  name   = "silver"
  bucket = aws_s3_bucket.lake_silver.id
}