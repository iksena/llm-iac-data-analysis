variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Specify the exact Instance ID with which to populate the data source."
  type        = string
  default     = null
}

variable "instance_tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired Instance."
  type        = map(string)
  default     = null
}

variable "filter" {
  description = "One or more name/value pairs to use as filters. There are several valid keys, for a full reference, check out describe-instances in the AWS CLI reference."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it. Useful for getting the administrator password for instances running Microsoft Windows."
  type        = bool
  default     = false
}

variable "get_user_data" {
  description = "Retrieve Base64 encoded User Data contents into the user_data_base64 attribute. A SHA-1 hash of the User Data contents will always be present in the user_data attribute."
  type        = bool
  default     = false
}

variable "timeouts_read" {
  description = "How long to wait for the data source to be available before timing out."
  type        = string
  default     = "20m"
}

# Validation: At least one of filter, instance_tags, or instance_id must be specified
locals {
  has_filter         = length(var.filter) > 0
  has_instance_tags  = var.instance_tags != null && length(var.instance_tags) > 0
  has_instance_id    = var.instance_id != null && var.instance_id != ""
  has_required_param = local.has_filter || local.has_instance_tags || local.has_instance_id
}

# Validation is handled by precondition in main.tf