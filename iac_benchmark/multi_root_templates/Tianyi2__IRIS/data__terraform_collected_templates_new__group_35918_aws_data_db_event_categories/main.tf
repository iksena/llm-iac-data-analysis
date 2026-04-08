data "aws_db_event_categories" "this" {
  region      = var.region
  source_type = var.source_type
}