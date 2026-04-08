resource "aws_kendra_faq" "this" {
  index_id      = var.index_id
  name          = var.name
  role_arn      = var.role_arn
  region        = var.region
  description   = var.description
  file_format   = var.file_format
  language_code = var.language_code
  tags          = var.tags

  s3_path {
    bucket = var.s3_path_bucket
    key    = var.s3_path_key
  }

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}