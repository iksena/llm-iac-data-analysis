data "aws_glue_registry" "this" {
  name   = var.name
  region = var.region
}