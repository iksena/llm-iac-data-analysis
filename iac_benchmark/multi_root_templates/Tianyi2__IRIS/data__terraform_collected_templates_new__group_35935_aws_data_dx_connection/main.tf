data "aws_dx_connection" "this" {
  region = var.region
  name   = var.name
}