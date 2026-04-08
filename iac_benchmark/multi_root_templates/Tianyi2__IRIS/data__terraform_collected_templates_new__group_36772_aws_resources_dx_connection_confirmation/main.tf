resource "aws_dx_connection_confirmation" "this" {
  connection_id = var.connection_id
  region        = var.region
}