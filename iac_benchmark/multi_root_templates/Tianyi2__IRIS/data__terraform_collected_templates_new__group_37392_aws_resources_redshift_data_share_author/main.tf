resource "aws_redshift_data_share_authorization" "this" {
  consumer_identifier = var.consumer_identifier
  data_share_arn      = var.data_share_arn
  region              = var.region
  allow_writes        = var.allow_writes
}