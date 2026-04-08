resource "aws_dataexchange_revision" "this" {
  data_set_id = var.data_set_id
  comment     = var.comment
  region      = var.region
  tags        = var.tags
}