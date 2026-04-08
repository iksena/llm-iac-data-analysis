resource "aws_codeartifact_repository" "this" {
  region       = var.region
  domain       = var.domain
  repository   = var.repository
  domain_owner = var.domain_owner
  description  = var.description
  tags         = var.tags

  dynamic "upstream" {
    for_each = var.upstream != null ? var.upstream : []
    content {
      repository_name = upstream.value.repository_name
    }
  }

  dynamic "external_connections" {
    for_each = var.external_connections != null ? var.external_connections : []
    content {
      external_connection_name = external_connections.value.external_connection_name
    }
  }
}