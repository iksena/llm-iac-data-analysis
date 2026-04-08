variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "image_id" {
  description = "ID of the image."
  type        = string

  validation {
    condition     = length(var.image_id) > 0
    error_message = "data_aws_workspaces_image, image_id must not be empty."
  }
}