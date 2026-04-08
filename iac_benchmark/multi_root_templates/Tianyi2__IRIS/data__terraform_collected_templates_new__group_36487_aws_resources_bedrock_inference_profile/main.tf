resource "aws_bedrock_inference_profile" "this" {
  name        = var.name
  description = var.description
  region      = var.region

  model_source {
    copy_from = var.model_source_copy_from
  }

  tags = var.tags

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}