resource "aws_s3tables_namespace" "this" {
  region           = var.region
  namespace        = var.namespace
  table_bucket_arn = var.table_bucket_arn
}