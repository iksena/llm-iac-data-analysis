variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "access_association_source" {
  description = "The identifier of the domain name access association source. For a VPCE, the value is the VPC endpoint ID."
  type        = string

  validation {
    condition     = length(var.access_association_source) > 0
    error_message = "resource_aws_api_gateway_domain_name_access_association, access_association_source must be a non-empty string."
  }
}

variable "access_association_source_type" {
  description = "The type of the domain name access association source. Valid values are VPCE."
  type        = string

  validation {
    condition     = contains(["VPCE"], var.access_association_source_type)
    error_message = "resource_aws_api_gateway_domain_name_access_association, access_association_source_type must be one of: VPCE."
  }
}

variable "domain_name_arn" {
  description = "The ARN of the domain name."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:apigateway:[^:]+:[^:]*:/domainnames/[^/]+$", var.domain_name_arn))
    error_message = "resource_aws_api_gateway_domain_name_access_association, domain_name_arn must be a valid API Gateway domain name ARN."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}