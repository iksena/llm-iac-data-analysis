variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "exclude_compliant_resources" {
  description = "Specifies whether to exclude resources that are compliant with the tag policy. You can use this parameter only if the include_compliance_details argument is also set to true."
  type        = bool
  default     = null

  validation {
    condition     = var.exclude_compliant_resources == null || var.include_compliance_details == true
    error_message = "data_aws_resourcegroupstaggingapi_resources, exclude_compliant_resources can only be used when include_compliance_details is set to true."
  }
}

variable "include_compliance_details" {
  description = "Specifies whether to include details regarding the compliance with the effective tag policy."
  type        = bool
  default     = null
}

variable "tag_filter" {
  description = "Specifies a list of Tag Filters (keys and values) to restrict the output to only those resources that have the specified tag and, if included, the specified value. Conflicts with resource_arn_list."
  type = object({
    key    = string
    values = optional(list(string))
  })
  default = null

  validation {
    condition     = var.tag_filter == null || var.resource_arn_list == null
    error_message = "data_aws_resourcegroupstaggingapi_resources, tag_filter conflicts with resource_arn_list - only one can be specified."
  }
}

variable "resource_type_filters" {
  description = "Constraints on the resources that you want returned. The format of each resource type is service:resourceType. For example, specifying a resource type of ec2 returns all Amazon EC2 resources (which includes EC2 instances). Specifying a resource type of ec2:instance returns only EC2 instances."
  type        = list(string)
  default     = null
}

variable "resource_arn_list" {
  description = "Specifies a list of ARNs of resources for which you want to retrieve tag data. Conflicts with tag_filter."
  type        = list(string)
  default     = null
}