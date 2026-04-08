resource "aws_finspace_kx_cluster" "this" {
  az_mode        = var.az_mode
  environment_id = var.environment_id
  name           = var.name
  release_label  = var.release_label
  type           = var.type

  capacity_configuration {
    node_type  = var.capacity_configuration.node_type
    node_count = var.capacity_configuration.node_count
  }

  vpc_configuration {
    vpc_id             = var.vpc_configuration.vpc_id
    security_group_ids = var.vpc_configuration.security_group_ids
    subnet_ids         = var.vpc_configuration.subnet_ids
    ip_address_type    = var.vpc_configuration.ip_address_type
  }

  region                 = var.region
  availability_zone_id   = var.availability_zone_id
  description            = var.description
  execution_role         = var.execution_role
  initialization_script  = var.initialization_script
  command_line_arguments = var.command_line_arguments

  dynamic "auto_scaling_configuration" {
    for_each = var.auto_scaling_configuration != null ? [var.auto_scaling_configuration] : []
    content {
      auto_scaling_metric        = auto_scaling_configuration.value.auto_scaling_metric
      min_node_count             = auto_scaling_configuration.value.min_node_count
      max_node_count             = auto_scaling_configuration.value.max_node_count
      metric_target              = auto_scaling_configuration.value.metric_target
      scale_in_cooldown_seconds  = auto_scaling_configuration.value.scale_in_cooldown_seconds
      scale_out_cooldown_seconds = auto_scaling_configuration.value.scale_out_cooldown_seconds
    }
  }

  dynamic "cache_storage_configurations" {
    for_each = var.cache_storage_configurations != null ? var.cache_storage_configurations : []
    content {
      type = cache_storage_configurations.value.type
      size = cache_storage_configurations.value.size
    }
  }

  dynamic "code" {
    for_each = var.code != null ? [var.code] : []
    content {
      s3_bucket         = code.value.s3_bucket
      s3_key            = code.value.s3_key
      s3_object_version = code.value.s3_object_version
    }
  }

  dynamic "database" {
    for_each = var.database != null ? var.database : []
    content {
      database_name = database.value.database_name
      changeset_id  = database.value.changeset_id
      dataview_name = database.value.dataview_name

      dynamic "cache_configurations" {
        for_each = database.value.cache_configurations != null ? database.value.cache_configurations : []
        content {
          cache_type = cache_configurations.value.cache_type
          db_paths   = cache_configurations.value.db_paths
        }
      }
    }
  }

  dynamic "savedown_storage_configuration" {
    for_each = var.savedown_storage_configuration != null ? [var.savedown_storage_configuration] : []
    content {
      type        = savedown_storage_configuration.value.type
      size        = savedown_storage_configuration.value.size
      volume_name = savedown_storage_configuration.value.volume_name
    }
  }

  dynamic "scaling_group_configuration" {
    for_each = var.scaling_group_configuration != null ? [var.scaling_group_configuration] : []
    content {
      scaling_group_name = scaling_group_configuration.value.scaling_group_name
      memory_reservation = scaling_group_configuration.value.memory_reservation
      node_count         = scaling_group_configuration.value.node_count
      cpu                = scaling_group_configuration.value.cpu
      memory_limit       = scaling_group_configuration.value.memory_limit
    }
  }

  dynamic "tickerplant_log_configuration" {
    for_each = var.tickerplant_log_configuration != null ? [var.tickerplant_log_configuration] : []
    content {
      tickerplant_log_volumes = tickerplant_log_configuration.value.tickerplant_log_volumes
    }
  }

  tags = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}