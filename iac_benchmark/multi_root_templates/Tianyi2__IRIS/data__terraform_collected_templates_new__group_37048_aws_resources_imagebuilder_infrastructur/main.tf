resource "aws_imagebuilder_infrastructure_configuration" "this" {
  instance_profile_name         = var.instance_profile_name
  name                          = var.name
  region                        = var.region
  description                   = var.description
  instance_types                = var.instance_types
  key_pair                      = var.key_pair
  resource_tags                 = var.resource_tags
  security_group_ids            = var.security_group_ids
  sns_topic_arn                 = var.sns_topic_arn
  subnet_id                     = var.subnet_id
  tags                          = var.tags
  terminate_instance_on_failure = var.terminate_instance_on_failure

  dynamic "instance_metadata_options" {
    for_each = var.instance_metadata_options != null ? [var.instance_metadata_options] : []
    content {
      http_put_response_hop_limit = instance_metadata_options.value.http_put_response_hop_limit
      http_tokens                 = instance_metadata_options.value.http_tokens
    }
  }

  dynamic "logging" {
    for_each = var.logging != null ? [var.logging] : []
    content {
      s3_logs {
        s3_bucket_name = logging.value.s3_logs.s3_bucket_name
        s3_key_prefix  = logging.value.s3_logs.s3_key_prefix
      }
    }
  }

  dynamic "placement" {
    for_each = var.placement != null ? [var.placement] : []
    content {
      availability_zone       = placement.value.availability_zone
      host_id                 = placement.value.host_id
      host_resource_group_arn = placement.value.host_resource_group_arn
      tenancy                 = placement.value.tenancy
    }
  }
}