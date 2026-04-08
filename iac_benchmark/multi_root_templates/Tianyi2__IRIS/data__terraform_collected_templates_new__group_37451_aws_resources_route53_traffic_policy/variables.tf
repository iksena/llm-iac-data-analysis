variable "name" {
  description = "Name of the traffic policy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53_traffic_policy, name cannot be empty"
  }
}

variable "document" {
  description = "Policy document. This is a JSON formatted string. For more information about building Route53 traffic policy documents, see the AWS Route53 Traffic Policy document format"
  type        = string

  validation {
    condition     = length(var.document) > 0
    error_message = "resource_aws_route53_traffic_policy, document cannot be empty"
  }

  validation {
    condition     = can(jsondecode(var.document))
    error_message = "resource_aws_route53_traffic_policy, document must be valid JSON"
  }
}

variable "comment" {
  description = "Comment for the traffic policy"
  type        = string
  default     = null
}