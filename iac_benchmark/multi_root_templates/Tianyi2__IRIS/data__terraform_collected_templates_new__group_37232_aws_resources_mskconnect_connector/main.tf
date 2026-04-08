resource "aws_mskconnect_connector" "this" {
  name                       = var.name
  kafkaconnect_version       = var.kafkaconnect_version
  connector_configuration    = var.connector_configuration
  service_execution_role_arn = var.service_execution_role_arn

  region      = var.region
  description = var.description
  tags        = var.tags

  capacity {
    dynamic "autoscaling" {
      for_each = var.capacity.autoscaling != null ? [var.capacity.autoscaling] : []
      content {
        max_worker_count = autoscaling.value.max_worker_count
        min_worker_count = autoscaling.value.min_worker_count
        mcu_count        = autoscaling.value.mcu_count

        dynamic "scale_in_policy" {
          for_each = autoscaling.value.scale_in_policy != null ? [autoscaling.value.scale_in_policy] : []
          content {
            cpu_utilization_percentage = scale_in_policy.value.cpu_utilization_percentage
          }
        }

        dynamic "scale_out_policy" {
          for_each = autoscaling.value.scale_out_policy != null ? [autoscaling.value.scale_out_policy] : []
          content {
            cpu_utilization_percentage = scale_out_policy.value.cpu_utilization_percentage
          }
        }
      }
    }

    dynamic "provisioned_capacity" {
      for_each = var.capacity.provisioned_capacity != null ? [var.capacity.provisioned_capacity] : []
      content {
        worker_count = provisioned_capacity.value.worker_count
        mcu_count    = provisioned_capacity.value.mcu_count
      }
    }
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = var.kafka_cluster.apache_kafka_cluster.bootstrap_servers

      vpc {
        security_groups = var.kafka_cluster.apache_kafka_cluster.vpc.security_groups
        subnets         = var.kafka_cluster.apache_kafka_cluster.vpc.subnets
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = var.kafka_cluster_client_authentication.authentication_type
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = var.kafka_cluster_encryption_in_transit.encryption_type
  }

  plugin {
    custom_plugin {
      arn      = var.plugin.custom_plugin.arn
      revision = var.plugin.custom_plugin.revision
    }
  }

  dynamic "log_delivery" {
    for_each = var.log_delivery != null ? [var.log_delivery] : []
    content {
      worker_log_delivery {
        dynamic "cloudwatch_logs" {
          for_each = log_delivery.value.worker_log_delivery.cloudwatch_logs != null ? [log_delivery.value.worker_log_delivery.cloudwatch_logs] : []
          content {
            enabled   = cloudwatch_logs.value.enabled
            log_group = cloudwatch_logs.value.log_group
          }
        }

        dynamic "firehose" {
          for_each = log_delivery.value.worker_log_delivery.firehose != null ? [log_delivery.value.worker_log_delivery.firehose] : []
          content {
            delivery_stream = firehose.value.delivery_stream
            enabled         = firehose.value.enabled
          }
        }

        dynamic "s3" {
          for_each = log_delivery.value.worker_log_delivery.s3 != null ? [log_delivery.value.worker_log_delivery.s3] : []
          content {
            bucket  = s3.value.bucket
            enabled = s3.value.enabled
            prefix  = s3.value.prefix
          }
        }
      }
    }
  }

  dynamic "worker_configuration" {
    for_each = var.worker_configuration != null ? [var.worker_configuration] : []
    content {
      arn      = worker_configuration.value.arn
      revision = worker_configuration.value.revision
    }
  }

  timeouts {
    create = "20m"
    update = "20m"
    delete = "10m"
  }
}