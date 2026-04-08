variable "enabled" {
  description = "Whether this continuous deployment policy is enabled"
  type        = bool
}

variable "staging_distribution_dns_names_items" {
  description = "A list of CloudFront domain names for the staging distribution"
  type        = list(string)
  validation {
    condition     = length(var.staging_distribution_dns_names_items) > 0
    error_message = "resource_aws_cloudfront_continuous_deployment_policy, staging_distribution_dns_names_items must contain at least one item."
  }
}

variable "staging_distribution_dns_names_quantity" {
  description = "Number of CloudFront domain names in the staging distribution"
  type        = number
  validation {
    condition     = var.staging_distribution_dns_names_quantity > 0
    error_message = "resource_aws_cloudfront_continuous_deployment_policy, staging_distribution_dns_names_quantity must be greater than 0."
  }
}

variable "traffic_config_type" {
  description = "Type of traffic configuration. Valid values are SingleWeight and SingleHeader"
  type        = string
  validation {
    condition     = contains(["SingleWeight", "SingleHeader"], var.traffic_config_type)
    error_message = "resource_aws_cloudfront_continuous_deployment_policy, traffic_config_type must be either 'SingleWeight' or 'SingleHeader'."
  }
}

variable "traffic_config_single_header_config" {
  description = "Determines which HTTP requests are sent to the staging distribution"
  type = object({
    header = string
    value  = string
  })
  default = null
  validation {
    condition = var.traffic_config_single_header_config == null || (
      var.traffic_config_single_header_config != null &&
      can(regex("^aws-cf-cd-", var.traffic_config_single_header_config.header))
    )
    error_message = "resource_aws_cloudfront_continuous_deployment_policy, traffic_config_single_header_config header must contain the prefix 'aws-cf-cd-'."
  }
}

variable "traffic_config_single_weight_config" {
  description = "Contains the percentage of traffic to send to the staging distribution"
  type = object({
    weight = string
    session_stickiness_config = optional(object({
      idle_ttl    = number
      maximum_ttl = number
    }))
  })
  default = null
  validation {
    condition = var.traffic_config_single_weight_config == null || (
      var.traffic_config_single_weight_config != null &&
      tonumber(var.traffic_config_single_weight_config.weight) >= 0 &&
      tonumber(var.traffic_config_single_weight_config.weight) <= 0.15
    )
    error_message = "resource_aws_cloudfront_continuous_deployment_policy, traffic_config_single_weight_config weight must be a decimal number between 0 and 0.15."
  }
  validation {
    condition = var.traffic_config_single_weight_config == null || (
      var.traffic_config_single_weight_config.session_stickiness_config == null || (
        var.traffic_config_single_weight_config.session_stickiness_config.idle_ttl >= 300 &&
        var.traffic_config_single_weight_config.session_stickiness_config.idle_ttl <= 3600
      )
    )
    error_message = "resource_aws_cloudfront_continuous_deployment_policy, traffic_config_single_weight_config session_stickiness_config idle_ttl must be between 300 and 3600 seconds."
  }
  validation {
    condition = var.traffic_config_single_weight_config == null || (
      var.traffic_config_single_weight_config.session_stickiness_config == null || (
        var.traffic_config_single_weight_config.session_stickiness_config.maximum_ttl >= 300 &&
        var.traffic_config_single_weight_config.session_stickiness_config.maximum_ttl <= 3600
      )
    )
    error_message = "resource_aws_cloudfront_continuous_deployment_policy, traffic_config_single_weight_config session_stickiness_config maximum_ttl must be between 300 and 3600 seconds."
  }
  validation {
    condition = var.traffic_config_single_weight_config == null || (
      var.traffic_config_single_weight_config.session_stickiness_config == null || (
        var.traffic_config_single_weight_config.session_stickiness_config.idle_ttl <= var.traffic_config_single_weight_config.session_stickiness_config.maximum_ttl
      )
    )
    error_message = "resource_aws_cloudfront_continuous_deployment_policy, traffic_config_single_weight_config session_stickiness_config idle_ttl must be less than or equal to maximum_ttl."
  }
}