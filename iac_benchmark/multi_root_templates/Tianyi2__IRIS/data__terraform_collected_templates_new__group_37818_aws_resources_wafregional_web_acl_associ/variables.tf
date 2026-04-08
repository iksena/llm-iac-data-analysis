variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "web_acl_id" {
  description = "The ID of the WAF Regional WebACL to create an association."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.web_acl_id))
    error_message = "resource_aws_wafregional_web_acl_association, web_acl_id must be a valid UUID format."
  }
}

variable "resource_arn" {
  description = "ARN of the resource to associate with. For example, an Application Load Balancer or API Gateway Stage."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:.*", var.resource_arn))
    error_message = "resource_aws_wafregional_web_acl_association, resource_arn must be a valid AWS ARN."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "10m")
  })
  default = {
    create = "10m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_wafregional_web_acl_association, timeouts.create must be a valid timeout format (e.g., '10m', '30s', '1h')."
  }
}