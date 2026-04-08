data "aws_transfer_server" "this" {
  region    = var.region
  server_id = var.server_id
}