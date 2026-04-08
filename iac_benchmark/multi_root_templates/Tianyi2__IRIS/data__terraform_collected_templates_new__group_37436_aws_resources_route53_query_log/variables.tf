variable "cloudwatch_log_group_arn" {
  description = "CloudWatch log group ARN to send query logs"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:logs:", var.cloudwatch_log_group_arn))
    error_message = "resource_aws_route53_query_log, cloudwatch_log_group_arn must be a valid CloudWatch log group ARN."
  }
}

variable "zone_id" {
  description = "Route53 hosted zone ID to enable query logs"
  type        = string

  validation {
    condition     = can(regex("^[A-Z0-9]{10,32}$", var.zone_id))
    error_message = "resource_aws_route53_query_log, zone_id must be a valid Route53 hosted zone ID."
  }
}