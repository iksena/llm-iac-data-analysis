resource "aws_api_gateway_rest_api" "this" {
  region                       = var.region
  api_key_source               = var.api_key_source
  binary_media_types           = var.binary_media_types
  body                         = var.body
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  minimum_compression_size     = var.minimum_compression_size
  name                         = var.name
  fail_on_warnings             = var.fail_on_warnings
  parameters                   = var.parameters
  policy                       = var.policy
  put_rest_api_mode            = var.put_rest_api_mode
  tags                         = var.tags

  dynamic "endpoint_configuration" {
    for_each = var.endpoint_configuration != null ? [var.endpoint_configuration] : []
    content {
      ip_address_type  = endpoint_configuration.value.ip_address_type
      types            = endpoint_configuration.value.types
      vpc_endpoint_ids = endpoint_configuration.value.vpc_endpoint_ids
    }
  }
}