variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "data_aws_connect_vocabulary, instance_id must be a valid UUID format (aaaaaaaa-bbbb-cccc-dddd-111111111111)."
  }
}

variable "name" {
  description = "Returns information on a specific Vocabulary by name"
  type        = string
  default     = null
}

variable "vocabulary_id" {
  description = "Returns information on a specific Vocabulary by Vocabulary id"
  type        = string
  default     = null

  validation {
    condition     = var.vocabulary_id == null || can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.vocabulary_id))
    error_message = "data_aws_connect_vocabulary, vocabulary_id must be a valid UUID format (cccccccc-bbbb-cccc-dddd-111111111111) when provided."
  }
}

# Validation to ensure either name or vocabulary_id is provided
locals {
  has_name_or_vocabulary_id = (var.name != null && var.name != "") || (var.vocabulary_id != null && var.vocabulary_id != "")
  # This will cause a plan-time error if neither name nor vocabulary_id is provided
  validation_check = local.has_name_or_vocabulary_id ? "valid" : file("ERROR: Either 'name' or 'vocabulary_id' must be provided for data_aws_connect_vocabulary")
}