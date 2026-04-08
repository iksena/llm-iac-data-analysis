resource "aws_s3_bucket" "this" {
  region              = var.region
  bucket              = var.bucket
  bucket_prefix       = var.bucket_prefix
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = var.tags

  # Deprecated arguments
  acceleration_status = var.acceleration_status
  acl                 = var.acl
  policy              = var.policy
  request_payer       = var.request_payer

  dynamic "grant" {
    for_each = var.grant
    content {
      id          = grant.value.id
      type        = grant.value.type
      permissions = grant.value.permissions
      uri         = grant.value.uri
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rule
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    content {
      id                                     = lifecycle_rule.value.id
      prefix                                 = lifecycle_rule.value.prefix
      tags                                   = lifecycle_rule.value.tags
      enabled                                = lifecycle_rule.value.enabled
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days

      dynamic "expiration" {
        for_each = lifecycle_rule.value.expiration != null ? [lifecycle_rule.value.expiration] : []
        content {
          date                         = expiration.value.date
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.transition
        content {
          date          = transition.value.date
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = lifecycle_rule.value.noncurrent_version_expiration != null ? [lifecycle_rule.value.noncurrent_version_expiration] : []
        content {
          days = noncurrent_version_expiration.value.days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value.noncurrent_version_transition
        content {
          days          = noncurrent_version_transition.value.days
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging != null ? [var.logging] : []
    content {
      target_bucket = logging.value.target_bucket
      target_prefix = logging.value.target_prefix
    }
  }

  dynamic "object_lock_configuration" {
    for_each = var.object_lock_configuration != null ? [var.object_lock_configuration] : []
    content {
      object_lock_enabled = object_lock_configuration.value.object_lock_enabled

      dynamic "rule" {
        for_each = object_lock_configuration.value.rule != null ? [object_lock_configuration.value.rule] : []
        content {
          dynamic "default_retention" {
            for_each = rule.value.default_retention != null ? [rule.value.default_retention] : []
            content {
              mode  = default_retention.value.mode
              days  = default_retention.value.days
              years = default_retention.value.years
            }
          }
        }
      }
    }
  }

  dynamic "replication_configuration" {
    for_each = var.replication_configuration != null ? [var.replication_configuration] : []
    content {
      role = replication_configuration.value.role

      dynamic "rules" {
        for_each = replication_configuration.value.rules
        content {
          delete_marker_replication_status = rules.value.delete_marker_replication_status
          id                               = rules.value.id
          prefix                           = rules.value.prefix
          priority                         = rules.value.priority
          status                           = rules.value.status

          dynamic "filter" {
            for_each = rules.value.filter != null ? [rules.value.filter] : []
            content {
              prefix = filter.value.prefix
              tags   = filter.value.tags
            }
          }

          dynamic "destination" {
            for_each = [rules.value.destination]
            content {
              bucket             = destination.value.bucket
              storage_class      = destination.value.storage_class
              replica_kms_key_id = destination.value.replica_kms_key_id
              account_id         = destination.value.account_id

              dynamic "access_control_translation" {
                for_each = destination.value.access_control_translation != null ? [destination.value.access_control_translation] : []
                content {
                  owner = access_control_translation.value.owner
                }
              }

              dynamic "replication_time" {
                for_each = destination.value.replication_time != null ? [destination.value.replication_time] : []
                content {
                  status  = replication_time.value.status
                  minutes = replication_time.value.minutes
                }
              }

              dynamic "metrics" {
                for_each = destination.value.metrics != null ? [destination.value.metrics] : []
                content {
                  status  = metrics.value.status
                  minutes = metrics.value.minutes
                }
              }
            }
          }

          dynamic "source_selection_criteria" {
            for_each = rules.value.source_selection_criteria != null ? [rules.value.source_selection_criteria] : []
            content {
              dynamic "sse_kms_encrypted_objects" {
                for_each = source_selection_criteria.value.sse_kms_encrypted_objects != null ? [source_selection_criteria.value.sse_kms_encrypted_objects] : []
                content {
                  enabled = sse_kms_encrypted_objects.value.enabled
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration != null ? [var.server_side_encryption_configuration] : []
    content {
      dynamic "rule" {
        for_each = [server_side_encryption_configuration.value.rule]
        content {
          bucket_key_enabled = rule.value.bucket_key_enabled

          dynamic "apply_server_side_encryption_by_default" {
            for_each = [rule.value.apply_server_side_encryption_by_default]
            content {
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
              kms_master_key_id = apply_server_side_encryption_by_default.value.kms_master_key_id
            }
          }
        }
      }
    }
  }

  dynamic "versioning" {
    for_each = var.versioning != null ? [var.versioning] : []
    content {
      enabled    = versioning.value.enabled
      mfa_delete = versioning.value.mfa_delete
    }
  }

  dynamic "website" {
    for_each = var.website != null ? [var.website] : []
    content {
      index_document           = website.value.index_document
      error_document           = website.value.error_document
      redirect_all_requests_to = website.value.redirect_all_requests_to
      routing_rules            = website.value.routing_rules
    }
  }

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}