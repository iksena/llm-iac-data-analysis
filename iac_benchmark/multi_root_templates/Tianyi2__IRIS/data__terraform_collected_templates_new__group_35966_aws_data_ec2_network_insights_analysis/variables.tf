variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "network_insights_analysis_id" {
  description = "ID of the Network Insights Analysis to select."
  type        = string
  default     = null

  validation {
    condition     = var.network_insights_analysis_id == null || can(regex("^nia-[0-9a-f]{8,17}$", var.network_insights_analysis_id))
    error_message = "data_aws_ec2_network_insights_analysis, network_insights_analysis_id must be a valid Network Insights Analysis ID starting with 'nia-'."
  }
}

variable "filter" {
  description = "Configuration block(s) for filtering Network Insights Analyzes."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = null

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.name != null && f.name != "" && length(f.values) > 0
    ])
    error_message = "data_aws_ec2_network_insights_analysis, filter blocks must have a non-empty name and at least one value."
  }

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : contains([
        "network-insights-analysis-id",
        "network-insights-path-id",
        "status",
        "tag-key",
        "tag-value"
      ], f.name)
    ])
    error_message = "data_aws_ec2_network_insights_analysis, filter name must be one of: network-insights-analysis-id, network-insights-path-id, status, tag-key, tag-value."
  }
}