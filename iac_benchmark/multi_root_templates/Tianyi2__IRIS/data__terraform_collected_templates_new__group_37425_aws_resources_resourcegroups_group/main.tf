resource "aws_resourcegroups_group" "this" {
  region      = var.region
  name        = var.name
  description = var.description
  tags        = var.tags

  resource_query {
    query = var.resource_query.query
    type  = var.resource_query.type
  }

  dynamic "configuration" {
    for_each = var.configuration
    content {
      type = configuration.value.type

      dynamic "parameters" {
        for_each = configuration.value.parameters
        content {
          name   = parameters.value.name
          values = parameters.value.values
        }
      }
    }
  }
}