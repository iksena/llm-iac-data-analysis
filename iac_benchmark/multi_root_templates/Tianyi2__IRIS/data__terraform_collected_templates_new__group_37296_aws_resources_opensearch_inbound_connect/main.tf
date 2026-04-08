resource "aws_opensearch_inbound_connection_accepter" "this" {
  connection_id = var.connection_id
  region        = var.region

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}