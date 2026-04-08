resource "aws_glue_workflow" "this" {
  name                   = var.name
  region                 = var.region
  default_run_properties = var.default_run_properties
  description            = var.description
  max_concurrent_runs    = var.max_concurrent_runs
  tags                   = var.tags
}