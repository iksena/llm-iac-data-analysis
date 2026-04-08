variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "linking_mode" {
  description = "Indicates whether to aggregate findings from all of the available Regions or from a specified list. The options are ALL_REGIONS, ALL_REGIONS_EXCEPT_SPECIFIED, SPECIFIED_REGIONS or NO_REGIONS."
  type        = string

  validation {
    condition = contains([
      "ALL_REGIONS",
      "ALL_REGIONS_EXCEPT_SPECIFIED",
      "SPECIFIED_REGIONS",
      "NO_REGIONS"
    ], var.linking_mode)
    error_message = "resource_aws_securityhub_finding_aggregator, linking_mode must be one of: ALL_REGIONS, ALL_REGIONS_EXCEPT_SPECIFIED, SPECIFIED_REGIONS, or NO_REGIONS."
  }
}

variable "specified_regions" {
  description = "List of regions to include or exclude (required if linking_mode is set to ALL_REGIONS_EXCEPT_SPECIFIED or SPECIFIED_REGIONS)"
  type        = list(string)
  default     = null

  validation {
    condition = (
      (var.linking_mode == "ALL_REGIONS_EXCEPT_SPECIFIED" || var.linking_mode == "SPECIFIED_REGIONS") && var.specified_regions != null
      ) || (
      (var.linking_mode == "ALL_REGIONS" || var.linking_mode == "NO_REGIONS") && var.specified_regions == null
    ) || var.specified_regions == null
    error_message = "resource_aws_securityhub_finding_aggregator, specified_regions is required when linking_mode is ALL_REGIONS_EXCEPT_SPECIFIED or SPECIFIED_REGIONS, and should be null otherwise."
  }
}