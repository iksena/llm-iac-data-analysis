resource "aws_msk_cluster" "this" {
  region                 = var.region
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring
  storage_mode           = var.storage_mode
  tags                   = var.tags

  broker_node_group_info {
    client_subnets  = var.broker_node_group_info.client_subnets
    instance_type   = var.broker_node_group_info.instance_type
    security_groups = var.broker_node_group_info.security_groups
    az_distribution = var.broker_node_group_info.az_distribution

    dynamic "connectivity_info" {
      for_each = var.broker_node_group_info.connectivity_info != null ? [var.broker_node_group_info.connectivity_info] : []
      content {
        dynamic "public_access" {
          for_each = connectivity_info.value.public_access != null ? [connectivity_info.value.public_access] : []
          content {
            type = public_access.value.type
          }
        }

        dynamic "vpc_connectivity" {
          for_each = connectivity_info.value.vpc_connectivity != null ? [connectivity_info.value.vpc_connectivity] : []
          content {
            dynamic "client_authentication" {
              for_each = vpc_connectivity.value.client_authentication != null ? [vpc_connectivity.value.client_authentication] : []
              content {
                tls = client_authentication.value.tls

                dynamic "sasl" {
                  for_each = client_authentication.value.sasl != null ? [client_authentication.value.sasl] : []
                  content {
                    iam   = sasl.value.iam
                    scram = sasl.value.scram
                  }
                }
              }
            }
          }
        }
      }
    }

    dynamic "storage_info" {
      for_each = var.broker_node_group_info.storage_info != null ? [var.broker_node_group_info.storage_info] : []
      content {
        dynamic "ebs_storage_info" {
          for_each = storage_info.value.ebs_storage_info != null ? [storage_info.value.ebs_storage_info] : []
          content {
            volume_size = ebs_storage_info.value.volume_size

            dynamic "provisioned_throughput" {
              for_each = ebs_storage_info.value.provisioned_throughput != null ? [ebs_storage_info.value.provisioned_throughput] : []
              content {
                enabled           = provisioned_throughput.value.enabled
                volume_throughput = provisioned_throughput.value.volume_throughput
              }
            }
          }
        }
      }
    }
  }

  dynamic "client_authentication" {
    for_each = var.client_authentication != null ? [var.client_authentication] : []
    content {
      unauthenticated = client_authentication.value.unauthenticated

      dynamic "sasl" {
        for_each = client_authentication.value.sasl != null ? [client_authentication.value.sasl] : []
        content {
          iam   = sasl.value.iam
          scram = sasl.value.scram
        }
      }

      dynamic "tls" {
        for_each = client_authentication.value.tls != null ? [client_authentication.value.tls] : []
        content {
          certificate_authority_arns = tls.value.certificate_authority_arns
        }
      }
    }
  }

  dynamic "configuration_info" {
    for_each = var.configuration_info != null ? [var.configuration_info] : []
    content {
      arn      = configuration_info.value.arn
      revision = configuration_info.value.revision
    }
  }

  dynamic "encryption_info" {
    for_each = var.encryption_info != null ? [var.encryption_info] : []
    content {
      encryption_at_rest_kms_key_arn = encryption_info.value.encryption_at_rest_kms_key_arn

      dynamic "encryption_in_transit" {
        for_each = encryption_info.value.encryption_in_transit != null ? [encryption_info.value.encryption_in_transit] : []
        content {
          client_broker = encryption_in_transit.value.client_broker
          in_cluster    = encryption_in_transit.value.in_cluster
        }
      }
    }
  }

  dynamic "open_monitoring" {
    for_each = var.open_monitoring != null ? [var.open_monitoring] : []
    content {
      prometheus {
        dynamic "jmx_exporter" {
          for_each = open_monitoring.value.prometheus.jmx_exporter != null ? [open_monitoring.value.prometheus.jmx_exporter] : []
          content {
            enabled_in_broker = jmx_exporter.value.enabled_in_broker
          }
        }

        dynamic "node_exporter" {
          for_each = open_monitoring.value.prometheus.node_exporter != null ? [open_monitoring.value.prometheus.node_exporter] : []
          content {
            enabled_in_broker = node_exporter.value.enabled_in_broker
          }
        }
      }
    }
  }

  dynamic "logging_info" {
    for_each = var.logging_info != null ? [var.logging_info] : []
    content {
      broker_logs {
        dynamic "cloudwatch_logs" {
          for_each = logging_info.value.broker_logs.cloudwatch_logs != null ? [logging_info.value.broker_logs.cloudwatch_logs] : []
          content {
            enabled   = cloudwatch_logs.value.enabled
            log_group = cloudwatch_logs.value.log_group
          }
        }

        dynamic "firehose" {
          for_each = logging_info.value.broker_logs.firehose != null ? [logging_info.value.broker_logs.firehose] : []
          content {
            enabled         = firehose.value.enabled
            delivery_stream = firehose.value.delivery_stream
          }
        }

        dynamic "s3" {
          for_each = logging_info.value.broker_logs.s3 != null ? [logging_info.value.broker_logs.s3] : []
          content {
            enabled = s3.value.enabled
            bucket  = s3.value.bucket
            prefix  = s3.value.prefix
          }
        }
      }
    }
  }
}