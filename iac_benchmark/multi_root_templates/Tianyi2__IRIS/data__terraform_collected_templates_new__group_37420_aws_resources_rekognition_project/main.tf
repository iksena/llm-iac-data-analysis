resource "aws_rekognition_project" "this" {
  name        = var.name
  region      = var.region
  auto_update = var.auto_update
  feature     = var.feature
  tags        = var.tags

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}