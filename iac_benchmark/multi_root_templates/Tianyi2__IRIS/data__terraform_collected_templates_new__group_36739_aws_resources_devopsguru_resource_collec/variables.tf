variable "type" {
  description = "Type of AWS resource collection to create. Valid values are AWS_CLOUD_FORMATION, AWS_SERVICE, and AWS_TAGS."
  type        = string

  validation {
    condition = contains([
      "AWS_CLOUD_FORMATION",
      "AWS_SERVICE",
      "AWS_TAGS"
    ], var.type)
    error_message = "resource_aws_devopsguru_resource_collection, type must be one of: AWS_CLOUD_FORMATION, AWS_SERVICE, AWS_TAGS."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cloudformation" {
  description = "A collection of AWS CloudFormation stacks."
  type = object({
    stack_names = list(string)
  })
  default = null

  validation {
    condition = var.cloudformation == null || (
      var.cloudformation != null &&
      var.cloudformation.stack_names != null &&
      length(var.cloudformation.stack_names) > 0
    )
    error_message = "resource_aws_devopsguru_resource_collection, cloudformation.stack_names must be a non-empty list when cloudformation is specified."
  }
}

variable "tags" {
  description = "AWS tags used to filter the resources in the resource collection."
  type = object({
    app_boundary_key = string
    tag_values       = list(string)
  })
  default = null

  validation {
    condition = var.tags == null || (
      var.tags != null &&
      var.tags.app_boundary_key != null &&
      startswith(var.tags.app_boundary_key, "DevOps-Guru-") &&
      var.tags.tag_values != null &&
      length(var.tags.tag_values) > 0
    )
    error_message = "resource_aws_devopsguru_resource_collection, tags.app_boundary_key must begin with 'DevOps-Guru-' and tags.tag_values must be a non-empty list when tags is specified."
  }
}