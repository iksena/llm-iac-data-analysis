locals {
  # Validation for merged API parameters - will fail at plan time if both are null
  merged_api_validation = var.merged_api_arn != null || var.merged_api_id != null ? "valid" : "One of merged_api_arn or merged_api_id must be specified"
  # Validation for source API parameters - will fail at plan time if both are null
  source_api_validation = var.source_api_arn != null || var.source_api_id != null ? "valid" : "One of source_api_arn or source_api_id must be specified"

  # These will cause errors at plan time if validation fails
  _merged_api_check = local.merged_api_validation == "valid" ? true : file("ERROR: ${local.merged_api_validation}")
  _source_api_check = local.source_api_validation == "valid" ? true : file("ERROR: ${local.source_api_validation}")
}

resource "aws_appsync_source_api_association" "this" {
  description    = var.description
  merged_api_arn = var.merged_api_arn
  merged_api_id  = var.merged_api_id
  source_api_arn = var.source_api_arn
  source_api_id  = var.source_api_id

  dynamic "source_api_association_config" {
    for_each = var.source_api_association_config != null ? [var.source_api_association_config] : []
    content {
      merge_type = source_api_association_config.value.merge_type
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}