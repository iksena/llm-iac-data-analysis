resource "aws_kendra_query_suggestions_block_list" "this" {
  index_id    = var.index_id
  name        = var.name
  role_arn    = var.role_arn
  description = var.description
  region      = var.region

  source_s3_path {
    bucket = var.source_s3_path_bucket
    key    = var.source_s3_path_key
  }

  tags = var.tags

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}