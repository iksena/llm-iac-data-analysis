data "aws_datapipeline_pipeline_definition" "this" {
  region      = var.region
  pipeline_id = var.pipeline_id
}