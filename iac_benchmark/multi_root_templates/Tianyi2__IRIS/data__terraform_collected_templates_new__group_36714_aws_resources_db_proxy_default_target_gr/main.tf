resource "aws_db_proxy_default_target_group" "this" {
  region        = var.region
  db_proxy_name = var.db_proxy_name

  dynamic "connection_pool_config" {
    for_each = var.connection_pool_config != null ? [var.connection_pool_config] : []
    content {
      connection_borrow_timeout    = connection_pool_config.value.connection_borrow_timeout
      init_query                   = connection_pool_config.value.init_query
      max_connections_percent      = connection_pool_config.value.max_connections_percent
      max_idle_connections_percent = connection_pool_config.value.max_idle_connections_percent
      session_pinning_filters      = connection_pool_config.value.session_pinning_filters
    }
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
  }
}