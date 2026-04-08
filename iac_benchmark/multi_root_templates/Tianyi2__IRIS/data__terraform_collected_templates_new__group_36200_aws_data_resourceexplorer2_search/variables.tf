variable "query_string" {
  description = "String that includes keywords and filters that specify the resources that you want to include in the results. For the complete syntax supported by the QueryString parameter, see Search query syntax reference for Resource Explorer. The search is completely case insensitive. You can specify an empty string to return all results up to the limit of 1,000 total results. The operation can return only the first 1,000 results. If the resource you want is not included, then use a different value for QueryString to refine the results."
  type        = string

  validation {
    condition     = var.query_string != null
    error_message = "data_resourceexplorer2_search, query_string must not be null."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_resourceexplorer2_search, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "view_arn" {
  description = "Specifies the Amazon resource name (ARN) of the view to use for the query. If you don't specify a value for this parameter, then the operation automatically uses the default view for the AWS Region in which you called this operation. If the Region either doesn't have a default view or if you don't have permission to use the default view, then the operation fails with a 401 Unauthorized exception."
  type        = string
  default     = null

  validation {
    condition     = var.view_arn == null || can(regex("^arn:aws[a-zA-Z-]*:resource-explorer-2:[a-z0-9-]+:[0-9]{12}:view/[a-zA-Z0-9-_]+$", var.view_arn))
    error_message = "data_resourceexplorer2_search, view_arn must be a valid Resource Explorer view ARN or null."
  }
}