resource "aws_athena_workgroup" "this" {
  region        = var.region
  name          = var.name
  description   = var.description
  state         = var.state
  tags          = var.tags
  force_destroy = var.force_destroy

  dynamic "configuration" {
    for_each = var.configuration != null ? [var.configuration] : []
    content {
      bytes_scanned_cutoff_per_query     = configuration.value.bytes_scanned_cutoff_per_query
      enforce_workgroup_configuration    = configuration.value.enforce_workgroup_configuration
      execution_role                     = configuration.value.execution_role
      publish_cloudwatch_metrics_enabled = configuration.value.publish_cloudwatch_metrics_enabled
      requester_pays_enabled             = configuration.value.requester_pays_enabled

      dynamic "engine_version" {
        for_each = configuration.value.engine_version != null ? [configuration.value.engine_version] : []
        content {
          selected_engine_version = engine_version.value.selected_engine_version
        }
      }

      dynamic "identity_center_configuration" {
        for_each = configuration.value.identity_center_configuration != null ? [configuration.value.identity_center_configuration] : []
        content {
          enable_identity_center       = identity_center_configuration.value.enable_identity_center
          identity_center_instance_arn = identity_center_configuration.value.identity_center_instance_arn
        }
      }

      dynamic "result_configuration" {
        for_each = configuration.value.result_configuration != null ? [configuration.value.result_configuration] : []
        content {
          expected_bucket_owner = result_configuration.value.expected_bucket_owner
          output_location       = result_configuration.value.output_location

          dynamic "acl_configuration" {
            for_each = result_configuration.value.acl_configuration != null ? [result_configuration.value.acl_configuration] : []
            content {
              s3_acl_option = acl_configuration.value.s3_acl_option
            }
          }

          dynamic "encryption_configuration" {
            for_each = result_configuration.value.encryption_configuration != null ? [result_configuration.value.encryption_configuration] : []
            content {
              encryption_option = encryption_configuration.value.encryption_option
              kms_key_arn       = encryption_configuration.value.kms_key_arn
            }
          }
        }
      }
    }
  }
}