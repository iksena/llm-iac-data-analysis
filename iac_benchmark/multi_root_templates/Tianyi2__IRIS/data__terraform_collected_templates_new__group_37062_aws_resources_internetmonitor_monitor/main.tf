resource "aws_internetmonitor_monitor" "this" {
  monitor_name                  = var.monitor_name
  region                        = var.region
  max_city_networks_to_monitor  = var.max_city_networks_to_monitor
  resources                     = var.resources
  status                        = var.status
  tags                          = var.tags
  traffic_percentage_to_monitor = var.traffic_percentage_to_monitor

  dynamic "health_events_config" {
    for_each = var.health_events_config != null ? [var.health_events_config] : []
    content {
      availability_score_threshold = health_events_config.value.availability_score_threshold
      performance_score_threshold  = health_events_config.value.performance_score_threshold
    }
  }

  dynamic "internet_measurements_log_delivery" {
    for_each = var.internet_measurements_log_delivery != null ? [var.internet_measurements_log_delivery] : []
    content {
      s3_config {
        bucket_name         = internet_measurements_log_delivery.value.s3_config.bucket_name
        bucket_prefix       = internet_measurements_log_delivery.value.s3_config.bucket_prefix
        log_delivery_status = internet_measurements_log_delivery.value.s3_config.log_delivery_status
      }
    }
  }
}