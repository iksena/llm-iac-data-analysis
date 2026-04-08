resource "aws_redshift_data_share_consumer_association" "this" {
  data_share_arn           = var.data_share_arn
  region                   = var.region
  allow_writes             = var.allow_writes
  associate_entire_account = var.associate_entire_account
  consumer_arn             = var.consumer_arn
  consumer_region          = var.consumer_region
}