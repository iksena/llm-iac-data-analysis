resource "aws_transfer_server" "this" {
  region                           = var.region
  certificate                      = var.certificate
  domain                           = var.domain
  protocols                        = var.protocols
  endpoint_type                    = var.endpoint_type
  invocation_role                  = var.invocation_role
  host_key                         = var.host_key
  url                              = var.url
  identity_provider_type           = var.identity_provider_type
  directory_id                     = var.directory_id
  function                         = var.function
  sftp_authentication_methods      = var.sftp_authentication_methods
  logging_role                     = var.logging_role
  force_destroy                    = var.force_destroy
  post_authentication_login_banner = var.post_authentication_login_banner
  pre_authentication_login_banner  = var.pre_authentication_login_banner
  security_policy_name             = var.security_policy_name
  structured_log_destinations      = var.structured_log_destinations
  tags                             = var.tags

  dynamic "endpoint_details" {
    for_each = var.endpoint_details != null ? [var.endpoint_details] : []
    content {
      address_allocation_ids = endpoint_details.value.address_allocation_ids
      security_group_ids     = endpoint_details.value.security_group_ids
      subnet_ids             = endpoint_details.value.subnet_ids
      vpc_endpoint_id        = endpoint_details.value.vpc_endpoint_id
      vpc_id                 = endpoint_details.value.vpc_id
    }
  }

  dynamic "protocol_details" {
    for_each = var.protocol_details != null ? [var.protocol_details] : []
    content {
      as2_transports              = protocol_details.value.as2_transports
      passive_ip                  = protocol_details.value.passive_ip
      set_stat_option             = protocol_details.value.set_stat_option
      tls_session_resumption_mode = protocol_details.value.tls_session_resumption_mode
    }
  }

  dynamic "s3_storage_options" {
    for_each = var.s3_storage_options != null ? [var.s3_storage_options] : []
    content {
      directory_listing_optimization = s3_storage_options.value.directory_listing_optimization
    }
  }

  dynamic "workflow_details" {
    for_each = var.workflow_details != null ? [var.workflow_details] : []
    content {
      dynamic "on_upload" {
        for_each = workflow_details.value.on_upload != null ? [workflow_details.value.on_upload] : []
        content {
          execution_role = on_upload.value.execution_role
          workflow_id    = on_upload.value.workflow_id
        }
      }

      dynamic "on_partial_upload" {
        for_each = workflow_details.value.on_partial_upload != null ? [workflow_details.value.on_partial_upload] : []
        content {
          execution_role = on_partial_upload.value.execution_role
          workflow_id    = on_partial_upload.value.workflow_id
        }
      }
    }
  }
}