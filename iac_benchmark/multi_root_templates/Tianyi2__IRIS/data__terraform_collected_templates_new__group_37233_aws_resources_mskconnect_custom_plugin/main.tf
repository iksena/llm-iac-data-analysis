resource "aws_mskconnect_custom_plugin" "this" {
  region       = var.region
  name         = var.name
  content_type = var.content_type
  description  = var.description
  tags         = var.tags

  location {
    s3 {
      bucket_arn     = var.s3_bucket_arn
      file_key       = var.s3_file_key
      object_version = var.s3_object_version
    }
  }

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}