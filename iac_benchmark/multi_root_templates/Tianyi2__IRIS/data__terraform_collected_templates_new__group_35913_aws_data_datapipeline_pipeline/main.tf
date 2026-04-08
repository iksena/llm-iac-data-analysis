data "aws_datapipeline_pipeline" "this" {
  region      = var.region
  pipeline_id = var.pipeline_id
}