variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of Pipeline"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_datapipeline_pipeline, name must be a non-empty string."
  }
}

variable "description" {
  description = "The description of Pipeline"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}