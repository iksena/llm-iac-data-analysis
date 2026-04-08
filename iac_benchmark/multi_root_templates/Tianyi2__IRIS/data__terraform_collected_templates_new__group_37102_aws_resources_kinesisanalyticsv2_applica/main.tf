resource "aws_kinesisanalyticsv2_application" "this" {
  region                 = var.region
  name                   = var.name
  runtime_environment    = var.runtime_environment
  service_execution_role = var.service_execution_role
  application_mode       = var.application_mode
  description            = var.description
  force_stop             = var.force_stop
  start_application      = var.start_application
  tags                   = var.tags

  dynamic "application_configuration" {
    for_each = var.application_configuration != null ? [var.application_configuration] : []
    content {
      dynamic "application_code_configuration" {
        for_each = application_configuration.value.application_code_configuration != null ? [application_configuration.value.application_code_configuration] : []
        content {
          code_content_type = application_code_configuration.value.code_content_type

          dynamic "code_content" {
            for_each = application_code_configuration.value.code_content != null ? [application_code_configuration.value.code_content] : []
            content {
              dynamic "s3_content_location" {
                for_each = code_content.value.s3_content_location != null ? [code_content.value.s3_content_location] : []
                content {
                  bucket_arn     = s3_content_location.value.bucket_arn
                  file_key       = s3_content_location.value.file_key
                  object_version = s3_content_location.value.object_version
                }
              }
              text_content = code_content.value.text_content
            }
          }
        }
      }

      dynamic "application_snapshot_configuration" {
        for_each = application_configuration.value.application_snapshot_configuration != null ? [application_configuration.value.application_snapshot_configuration] : []
        content {
          snapshots_enabled = application_snapshot_configuration.value.snapshots_enabled
        }
      }

      dynamic "environment_properties" {
        for_each = application_configuration.value.environment_properties != null ? [application_configuration.value.environment_properties] : []
        content {
          dynamic "property_group" {
            for_each = environment_properties.value.property_group
            content {
              property_group_id = property_group.value.property_group_id
              property_map      = property_group.value.property_map
            }
          }
        }
      }

      dynamic "flink_application_configuration" {
        for_each = application_configuration.value.flink_application_configuration != null ? [application_configuration.value.flink_application_configuration] : []
        content {
          dynamic "checkpoint_configuration" {
            for_each = flink_application_configuration.value.checkpoint_configuration != null ? [flink_application_configuration.value.checkpoint_configuration] : []
            content {
              configuration_type            = checkpoint_configuration.value.configuration_type
              checkpointing_enabled         = checkpoint_configuration.value.checkpointing_enabled
              checkpoint_interval           = checkpoint_configuration.value.checkpoint_interval
              min_pause_between_checkpoints = checkpoint_configuration.value.min_pause_between_checkpoints
            }
          }

          dynamic "monitoring_configuration" {
            for_each = flink_application_configuration.value.monitoring_configuration != null ? [flink_application_configuration.value.monitoring_configuration] : []
            content {
              configuration_type = monitoring_configuration.value.configuration_type
              log_level          = monitoring_configuration.value.log_level
              metrics_level      = monitoring_configuration.value.metrics_level
            }
          }

          dynamic "parallelism_configuration" {
            for_each = flink_application_configuration.value.parallelism_configuration != null ? [flink_application_configuration.value.parallelism_configuration] : []
            content {
              configuration_type   = parallelism_configuration.value.configuration_type
              auto_scaling_enabled = parallelism_configuration.value.auto_scaling_enabled
              parallelism          = parallelism_configuration.value.parallelism
              parallelism_per_kpu  = parallelism_configuration.value.parallelism_per_kpu
            }
          }
        }
      }

      dynamic "run_configuration" {
        for_each = application_configuration.value.run_configuration != null ? [application_configuration.value.run_configuration] : []
        content {
          dynamic "application_restore_configuration" {
            for_each = run_configuration.value.application_restore_configuration != null ? [run_configuration.value.application_restore_configuration] : []
            content {
              application_restore_type = application_restore_configuration.value.application_restore_type
              snapshot_name            = application_restore_configuration.value.snapshot_name
            }
          }

          dynamic "flink_run_configuration" {
            for_each = run_configuration.value.flink_run_configuration != null ? [run_configuration.value.flink_run_configuration] : []
            content {
              allow_non_restored_state = flink_run_configuration.value.allow_non_restored_state
            }
          }
        }
      }

      dynamic "sql_application_configuration" {
        for_each = application_configuration.value.sql_application_configuration != null ? [application_configuration.value.sql_application_configuration] : []
        content {
          dynamic "input" {
            for_each = sql_application_configuration.value.input != null ? sql_application_configuration.value.input : []
            content {
              name_prefix = input.value.name_prefix

              input_schema {
                dynamic "record_column" {
                  for_each = input.value.input_schema.record_column
                  content {
                    name     = record_column.value.name
                    sql_type = record_column.value.sql_type
                    mapping  = record_column.value.mapping
                  }
                }

                record_format {
                  record_format_type = input.value.input_schema.record_format.record_format_type

                  mapping_parameters {
                    dynamic "csv_mapping_parameters" {
                      for_each = input.value.input_schema.record_format.mapping_parameters.csv_mapping_parameters != null ? [input.value.input_schema.record_format.mapping_parameters.csv_mapping_parameters] : []
                      content {
                        record_column_delimiter = csv_mapping_parameters.value.record_column_delimiter
                        record_row_delimiter    = csv_mapping_parameters.value.record_row_delimiter
                      }
                    }

                    dynamic "json_mapping_parameters" {
                      for_each = input.value.input_schema.record_format.mapping_parameters.json_mapping_parameters != null ? [input.value.input_schema.record_format.mapping_parameters.json_mapping_parameters] : []
                      content {
                        record_row_path = json_mapping_parameters.value.record_row_path
                      }
                    }
                  }
                }

                record_encoding = input.value.input_schema.record_encoding
              }

              dynamic "input_parallelism" {
                for_each = input.value.input_parallelism != null ? [input.value.input_parallelism] : []
                content {
                  count = input_parallelism.value.count
                }
              }

              dynamic "input_processing_configuration" {
                for_each = input.value.input_processing_configuration != null ? [input.value.input_processing_configuration] : []
                content {
                  input_lambda_processor {
                    resource_arn = input_processing_configuration.value.input_lambda_processor.resource_arn
                  }
                }
              }

              dynamic "input_starting_position_configuration" {
                for_each = input.value.input_starting_position_configuration != null ? [input.value.input_starting_position_configuration] : []
                content {
                  input_starting_position = input_starting_position_configuration.value.input_starting_position
                }
              }

              dynamic "kinesis_firehose_input" {
                for_each = input.value.kinesis_firehose_input != null ? [input.value.kinesis_firehose_input] : []
                content {
                  resource_arn = kinesis_firehose_input.value.resource_arn
                }
              }

              dynamic "kinesis_streams_input" {
                for_each = input.value.kinesis_streams_input != null ? [input.value.kinesis_streams_input] : []
                content {
                  resource_arn = kinesis_streams_input.value.resource_arn
                }
              }
            }
          }

          dynamic "output" {
            for_each = sql_application_configuration.value.output != null ? sql_application_configuration.value.output : []
            content {
              name = output.value.name

              destination_schema {
                record_format_type = output.value.destination_schema.record_format_type
              }

              dynamic "kinesis_firehose_output" {
                for_each = output.value.kinesis_firehose_output != null ? [output.value.kinesis_firehose_output] : []
                content {
                  resource_arn = kinesis_firehose_output.value.resource_arn
                }
              }

              dynamic "kinesis_streams_output" {
                for_each = output.value.kinesis_streams_output != null ? [output.value.kinesis_streams_output] : []
                content {
                  resource_arn = kinesis_streams_output.value.resource_arn
                }
              }

              dynamic "lambda_output" {
                for_each = output.value.lambda_output != null ? [output.value.lambda_output] : []
                content {
                  resource_arn = lambda_output.value.resource_arn
                }
              }
            }
          }

          dynamic "reference_data_source" {
            for_each = sql_application_configuration.value.reference_data_source != null ? sql_application_configuration.value.reference_data_source : []
            content {
              table_name = reference_data_source.value.table_name

              reference_schema {
                dynamic "record_column" {
                  for_each = reference_data_source.value.reference_schema.record_column
                  content {
                    name     = record_column.value.name
                    sql_type = record_column.value.sql_type
                    mapping  = record_column.value.mapping
                  }
                }

                record_format {
                  record_format_type = reference_data_source.value.reference_schema.record_format.record_format_type

                  mapping_parameters {
                    dynamic "csv_mapping_parameters" {
                      for_each = reference_data_source.value.reference_schema.record_format.mapping_parameters.csv_mapping_parameters != null ? [reference_data_source.value.reference_schema.record_format.mapping_parameters.csv_mapping_parameters] : []
                      content {
                        record_column_delimiter = csv_mapping_parameters.value.record_column_delimiter
                        record_row_delimiter    = csv_mapping_parameters.value.record_row_delimiter
                      }
                    }

                    dynamic "json_mapping_parameters" {
                      for_each = reference_data_source.value.reference_schema.record_format.mapping_parameters.json_mapping_parameters != null ? [reference_data_source.value.reference_schema.record_format.mapping_parameters.json_mapping_parameters] : []
                      content {
                        record_row_path = json_mapping_parameters.value.record_row_path
                      }
                    }
                  }
                }

                record_encoding = reference_data_source.value.reference_schema.record_encoding
              }

              s3_reference_data_source {
                bucket_arn = reference_data_source.value.s3_reference_data_source.bucket_arn
                file_key   = reference_data_source.value.s3_reference_data_source.file_key
              }
            }
          }
        }
      }

      dynamic "vpc_configuration" {
        for_each = application_configuration.value.vpc_configuration != null ? [application_configuration.value.vpc_configuration] : []
        content {
          security_group_ids = vpc_configuration.value.security_group_ids
          subnet_ids         = vpc_configuration.value.subnet_ids
        }
      }
    }
  }

  dynamic "cloudwatch_logging_options" {
    for_each = var.cloudwatch_logging_options != null ? [var.cloudwatch_logging_options] : []
    content {
      log_stream_arn = cloudwatch_logging_options.value.log_stream_arn
    }
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}