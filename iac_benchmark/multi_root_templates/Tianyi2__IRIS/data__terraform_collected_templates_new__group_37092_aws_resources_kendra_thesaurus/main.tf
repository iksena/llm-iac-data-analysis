resource "aws_kendra_thesaurus" "this" {
  index_id    = var.index_id
  name        = var.name
  role_arn    = var.role_arn
  region      = var.region
  description = var.description
  tags        = var.tags

  source_s3_path {
    bucket = var.source_s3_path.bucket
    key    = var.source_s3_path.key
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}