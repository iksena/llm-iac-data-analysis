resource "aws_sagemaker_hub" "this" {
  region              = var.region
  hub_name            = var.hub_name
  hub_description     = var.hub_description
  hub_display_name    = var.hub_display_name
  hub_search_keywords = var.hub_search_keywords

  dynamic "s3_storage_config" {
    for_each = var.s3_storage_config != null ? [var.s3_storage_config] : []
    content {
      s3_output_path = s3_storage_config.value.s3_output_path
    }
  }

  tags = var.tags
}