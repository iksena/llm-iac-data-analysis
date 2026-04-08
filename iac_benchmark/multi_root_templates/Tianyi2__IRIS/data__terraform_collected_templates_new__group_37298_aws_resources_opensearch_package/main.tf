resource "aws_opensearch_package" "this" {
  region              = var.region
  engine_version      = var.engine_version
  package_name        = var.package_name
  package_type        = var.package_type
  package_description = var.package_description

  package_source {
    s3_bucket_name = var.package_source.s3_bucket_name
    s3_key         = var.package_source.s3_key
  }
}