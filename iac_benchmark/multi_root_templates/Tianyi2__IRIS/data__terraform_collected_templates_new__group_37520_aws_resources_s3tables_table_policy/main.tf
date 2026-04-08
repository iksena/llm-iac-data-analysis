resource "aws_s3tables_table_policy" "this" {
  region           = var.region
  resource_policy  = var.resource_policy
  name             = var.name
  namespace        = var.namespace
  table_bucket_arn = var.table_bucket_arn
}