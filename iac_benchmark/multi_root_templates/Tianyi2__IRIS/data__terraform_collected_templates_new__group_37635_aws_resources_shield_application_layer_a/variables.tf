variable "resource_arn" {
  type        = string
  description = "ARN of the resource to protect (Cloudfront Distributions and ALBs only at this time)."

  validation {
    condition     = can(regex("^arn:[^:]+:(cloudfront|elasticloadbalancing):[^:]*:[^:]*:(distribution|loadbalancer)/.+", var.resource_arn))
    error_message = "resource_aws_shield_application_layer_automatic_response, resource_arn must be a valid ARN for CloudFront distribution or Application Load Balancer."
  }
}

variable "action" {
  type        = string
  description = "One of COUNT or BLOCK."

  validation {
    condition     = contains(["COUNT", "BLOCK"], var.action)
    error_message = "resource_aws_shield_application_layer_automatic_response, action must be either 'COUNT' or 'BLOCK'."
  }
}