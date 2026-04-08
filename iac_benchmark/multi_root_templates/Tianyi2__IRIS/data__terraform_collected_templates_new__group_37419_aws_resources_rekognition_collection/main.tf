resource "aws_rekognition_collection" "this" {
  collection_id = var.collection_id
  region        = var.region
  tags          = var.tags

  timeouts {
    create = var.create_timeout
  }
}