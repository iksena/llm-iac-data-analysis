resource "aws_cloudsearch_domain" "this" {
  name     = var.name
  region   = var.region
  multi_az = var.multi_az

  dynamic "endpoint_options" {
    for_each = var.endpoint_options != null ? [var.endpoint_options] : []
    content {
      enforce_https       = endpoint_options.value.enforce_https
      tls_security_policy = endpoint_options.value.tls_security_policy
    }
  }

  dynamic "scaling_parameters" {
    for_each = var.scaling_parameters != null ? [var.scaling_parameters] : []
    content {
      desired_instance_type     = scaling_parameters.value.desired_instance_type
      desired_partition_count   = scaling_parameters.value.desired_partition_count
      desired_replication_count = scaling_parameters.value.desired_replication_count
    }
  }

  dynamic "index_field" {
    for_each = var.index_field
    content {
      name            = index_field.value.name
      type            = index_field.value.type
      analysis_scheme = index_field.value.analysis_scheme
      default_value   = index_field.value.default_value
      facet           = index_field.value.facet
      highlight       = index_field.value.highlight
      return          = index_field.value.return
      search          = index_field.value.search
      sort            = index_field.value.sort
      source_fields   = index_field.value.source_fields
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "20m"
  }
}