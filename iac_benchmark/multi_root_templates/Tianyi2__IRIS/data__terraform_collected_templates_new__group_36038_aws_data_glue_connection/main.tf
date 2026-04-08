data "aws_glue_connection" "this" {
  id     = var.id
  region = var.region
}