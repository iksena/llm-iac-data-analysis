resource "aws_datapipeline_pipeline" "this" {
  region      = var.region
  name        = var.name
  description = var.description
  tags        = var.tags
}