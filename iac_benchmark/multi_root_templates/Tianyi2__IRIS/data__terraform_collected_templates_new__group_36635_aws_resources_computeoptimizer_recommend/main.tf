resource "aws_computeoptimizer_recommendation_preferences" "this" {
  resource_type                   = var.resource_type
  enhanced_infrastructure_metrics = var.enhanced_infrastructure_metrics
  inferred_workload_types         = var.inferred_workload_types
  look_back_period                = var.look_back_period
  region                          = var.region
  savings_estimation_mode         = var.savings_estimation_mode

  dynamic "scope" {
    for_each = var.scope != null ? [var.scope] : []
    content {
      name  = scope.value.name
      value = scope.value.value
    }
  }

  dynamic "external_metrics_preference" {
    for_each = var.external_metrics_preference != null ? [var.external_metrics_preference] : []
    content {
      source = external_metrics_preference.value.source
    }
  }

  dynamic "preferred_resource" {
    for_each = var.preferred_resource != null ? [var.preferred_resource] : []
    content {
      name         = preferred_resource.value.name
      exclude_list = preferred_resource.value.exclude_list
      include_list = preferred_resource.value.include_list
    }
  }

  dynamic "utilization_preference" {
    for_each = var.utilization_preference != null ? [var.utilization_preference] : []
    content {
      metric_name = utilization_preference.value.metric_name

      dynamic "metric_parameters" {
        for_each = utilization_preference.value.metric_parameters != null ? [utilization_preference.value.metric_parameters] : []
        content {
          headroom  = metric_parameters.value.headroom
          threshold = metric_parameters.value.threshold
        }
      }
    }
  }
}