data "aws_ssmcontacts_contact" "this" {
  arn    = var.arn
  region = var.region
}