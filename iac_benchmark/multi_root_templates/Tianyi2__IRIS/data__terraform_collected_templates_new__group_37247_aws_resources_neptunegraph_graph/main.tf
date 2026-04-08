resource "aws_neptunegraph_graph" "this" {
  provisioned_memory  = var.provisioned_memory
  region              = var.region
  deletion_protection = var.deletion_protection
  graph_name          = var.graph_name
  public_connectivity = var.public_connectivity
  replica_count       = var.replica_count
  kms_key_identifier  = var.kms_key_identifier
  tags                = var.tags

  dynamic "vector_search_configuration" {
    for_each = var.vector_search_configuration != null ? [var.vector_search_configuration] : []
    content {
      vector_search_dimension = vector_search_configuration.value.vector_search_dimension
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}