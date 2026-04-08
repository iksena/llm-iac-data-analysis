resource "aws_quicksight_ingestion" "this" {
  data_set_id    = var.data_set_id
  ingestion_id   = var.ingestion_id
  ingestion_type = var.ingestion_type
  aws_account_id = var.aws_account_id
  region         = var.region
}