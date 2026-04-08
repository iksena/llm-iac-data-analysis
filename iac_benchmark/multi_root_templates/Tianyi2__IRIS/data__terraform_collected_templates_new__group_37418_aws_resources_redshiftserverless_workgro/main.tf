resource "aws_redshiftserverless_workgroup" "this" {
  namespace_name = var.namespace_name
  workgroup_name = var.workgroup_name

  region               = var.region
  base_capacity        = var.base_capacity
  enhanced_vpc_routing = var.enhanced_vpc_routing
  max_capacity         = var.max_capacity
  port                 = var.port
  publicly_accessible  = var.publicly_accessible
  security_group_ids   = var.security_group_ids
  subnet_ids           = var.subnet_ids
  track_name           = var.track_name
  tags                 = var.tags

  dynamic "price_performance_target" {
    for_each = var.price_performance_target != null ? [var.price_performance_target] : []
    content {
      enabled = price_performance_target.value.enabled
      level   = price_performance_target.value.level
    }
  }

  dynamic "config_parameter" {
    for_each = var.config_parameter != null ? var.config_parameter : []
    content {
      parameter_key   = config_parameter.value.parameter_key
      parameter_value = config_parameter.value.parameter_value
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}