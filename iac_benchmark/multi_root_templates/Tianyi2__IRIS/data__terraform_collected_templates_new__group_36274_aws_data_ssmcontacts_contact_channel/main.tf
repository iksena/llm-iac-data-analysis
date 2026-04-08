data "aws_ssmcontacts_contact_channel" "this" {
  arn    = var.arn
  region = var.region
}