variable "network_insights_path_id" {
  description = "ID of the Network Insights Path to run an analysis on"
  type        = string

  validation {
    condition     = can(regex("^nip-[0-9a-f]{17}$", var.network_insights_path_id))
    error_message = "resource_aws_ec2_network_insights_analysis, network_insights_path_id must be a valid Network Insights Path ID starting with 'nip-' followed by 17 hexadecimal characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_ec2_network_insights_analysis, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}

variable "filter_in_arns" {
  description = "A list of ARNs for resources the path must traverse"
  type        = list(string)
  default     = null

  validation {
    condition = var.filter_in_arns == null || alltrue([
      for arn in var.filter_in_arns : can(regex("^arn:aws:[a-z0-9\\-]+:[a-z0-9\\-]*:[0-9]*:.+", arn))
    ])
    error_message = "resource_aws_ec2_network_insights_analysis, filter_in_arns must be a list of valid ARN formats or null."
  }
}

variable "wait_for_completion" {
  description = "If enabled, the resource will wait for the Network Insights Analysis status to change to succeeded or failed. Setting this to false will skip the process"
  type        = bool
  default     = true

  validation {
    condition     = var.wait_for_completion == true || var.wait_for_completion == false
    error_message = "resource_aws_ec2_network_insights_analysis, wait_for_completion must be a boolean value (true or false)."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]+$", k)) && can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]*$", v))
    ])
    error_message = "resource_aws_ec2_network_insights_analysis, tags keys and values must contain only valid characters (letters, numbers, spaces, and the following characters: _.:/=+-@)."
  }
}