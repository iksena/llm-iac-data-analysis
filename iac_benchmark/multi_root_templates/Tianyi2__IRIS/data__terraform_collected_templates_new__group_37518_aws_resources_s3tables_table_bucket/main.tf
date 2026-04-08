resource "aws_s3tables_table_bucket" "this" {
  name          = var.name
  force_destroy = var.force_destroy
  region        = var.region
}