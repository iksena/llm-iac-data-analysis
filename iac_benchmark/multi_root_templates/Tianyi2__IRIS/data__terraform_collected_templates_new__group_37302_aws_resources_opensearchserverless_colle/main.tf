resource "aws_opensearchserverless_collection" "this" {
  name             = var.name
  region           = var.region
  description      = var.description
  standby_replicas = var.standby_replicas
  tags             = var.tags
  type             = var.type

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}