resource "aws_dx_connection_association" "this" {
  region        = var.region
  connection_id = var.connection_id
  lag_id        = var.lag_id
}