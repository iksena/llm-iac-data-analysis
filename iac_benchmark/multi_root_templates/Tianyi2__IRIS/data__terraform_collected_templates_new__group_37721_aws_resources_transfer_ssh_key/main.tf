resource "aws_transfer_ssh_key" "this" {
  region    = var.region
  server_id = var.server_id
  user_name = var.user_name
  body      = var.body
}