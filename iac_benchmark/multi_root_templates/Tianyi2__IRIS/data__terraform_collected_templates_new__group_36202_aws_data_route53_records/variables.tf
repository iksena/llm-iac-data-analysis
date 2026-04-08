variable "name_regex" {
  description = "Regex string to apply to the resource record names returned by AWS"
  type        = string
  default     = null

  validation {
    condition     = var.name_regex == null || can(regex(var.name_regex, "test"))
    error_message = "data_aws_route53_records, name_regex must be a valid regex pattern or null."
  }
}

variable "zone_id" {
  description = "The ID of the hosted zone that contains the resource record sets that you want to list"
  type        = string

  validation {
    condition     = can(regex("^Z[0-9A-Z]{13,31}$", var.zone_id))
    error_message = "data_aws_route53_records, zone_id must be a valid Route 53 hosted zone ID (starts with 'Z' followed by 13-31 alphanumeric characters)."
  }
}