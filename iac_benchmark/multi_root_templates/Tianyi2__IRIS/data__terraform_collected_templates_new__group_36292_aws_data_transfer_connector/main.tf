data "aws_transfer_connector" "this" {
  region = var.region
  id     = var.id
}