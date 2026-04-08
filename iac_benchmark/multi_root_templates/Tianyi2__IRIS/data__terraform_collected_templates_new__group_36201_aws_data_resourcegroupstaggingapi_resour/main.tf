data "aws_resourcegroupstaggingapi_resources" "this" {
  region                      = var.region
  exclude_compliant_resources = var.exclude_compliant_resources
  include_compliance_details  = var.include_compliance_details
  resource_type_filters       = var.resource_type_filters
  resource_arn_list           = var.resource_arn_list

  dynamic "tag_filter" {
    for_each = var.tag_filter != null ? [var.tag_filter] : []
    content {
      key    = tag_filter.value.key
      values = tag_filter.value.values
    }
  }
}