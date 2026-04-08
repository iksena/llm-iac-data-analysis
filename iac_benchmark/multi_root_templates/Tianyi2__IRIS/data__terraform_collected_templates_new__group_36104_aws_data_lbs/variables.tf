variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_lbs, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired Load Balancers."
  type        = map(string)
  default     = null

  validation {
    condition     = var.tags == null || alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "data_aws_lbs, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}