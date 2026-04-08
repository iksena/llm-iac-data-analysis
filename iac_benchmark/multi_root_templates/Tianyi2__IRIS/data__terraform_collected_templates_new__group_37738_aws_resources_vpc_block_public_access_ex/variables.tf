variable "internet_gateway_exclusion_mode" {
  description = "Mode of exclusion from Block Public Access. The allowed values are `allow-egress` and `allow-bidirectional`."
  type        = string

  validation {
    condition     = contains(["allow-egress", "allow-bidirectional"], var.internet_gateway_exclusion_mode)
    error_message = "resource_aws_vpc_block_public_access_exclusion, internet_gateway_exclusion_mode must be one of: allow-egress, allow-bidirectional"
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "Id of the VPC to which this exclusion applies. Either this or the subnet_id needs to be provided."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Id of the subnet to which this exclusion applies. Either this or the vpc_id needs to be provided."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the exclusion."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}
}