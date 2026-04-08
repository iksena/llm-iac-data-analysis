data "aws_ssmcontacts_rotation" "this" {
  arn    = var.arn
  region = var.region
}