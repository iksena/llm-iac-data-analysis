variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the image being searched for. Cannot be used with name_regex or arn."
  type        = string
  default     = null

  validation {
    # Ensure at most one of name, name_regex, or arn is set to avoid ambiguous selection
    condition     = ((var.name != null ? 1 : 0) + (var.name_regex != null ? 1 : 0) + (var.arn != null ? 1 : 0)) <= 1
    error_message = "Only one of 'name', 'name_regex', or 'arn' may be set for data_aws_appstream_image."
  }
}

variable "name_regex" {
  description = "Regular expression name of the image being searched for. Cannot be used with arn or name."
  type        = string
  default     = null
}

variable "arn" {
  description = "Arn of the image being searched for. Cannot be used with name_regex or name."
  type        = string
  default     = null
}

variable "type" {
  description = "The type of image which must be (PUBLIC, PRIVATE, or SHARED)."
  type        = string
  default     = null

  validation {
    condition     = var.type == null || contains(["PUBLIC", "PRIVATE", "SHARED"], var.type)
    error_message = "data_aws_appstream_image, type must be PUBLIC, PRIVATE, or SHARED."
  }
}

variable "most_recent" {
  description = "Boolean that if it is set to true and there are multiple images returned the most recent will be returned. If it is set to false and there are multiple images return the datasource will error."
  type        = bool
  default     = null
}