data "aws_outposts_assets" "this" {
  arn              = var.arn
  host_id_filter   = var.host_id_filter
  status_id_filter = var.status_id_filter
}