data "aws_mskconnect_connector" "this" {
  region = var.region
  name   = var.name
}