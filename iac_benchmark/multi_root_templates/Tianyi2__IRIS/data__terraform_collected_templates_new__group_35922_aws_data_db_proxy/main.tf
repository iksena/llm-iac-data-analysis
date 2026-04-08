data "aws_db_proxy" "this" {
  name   = var.name
  region = var.region
}