resource "aws_s3tables_table_bucket_policy" "this" {
  region           = var.region
  resource_policy  = var.resource_policy
  table_bucket_arn = var.table_bucket_arn
}