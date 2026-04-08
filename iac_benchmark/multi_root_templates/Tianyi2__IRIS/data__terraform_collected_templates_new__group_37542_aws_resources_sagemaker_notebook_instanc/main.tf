resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "this" {
  region    = var.region
  name      = var.name
  on_create = var.on_create
  on_start  = var.on_start
  tags      = var.tags
}