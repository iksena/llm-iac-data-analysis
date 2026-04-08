variable "comment" {
  description = "An optional comment about the Field Level Encryption Config"
  type        = string
  default     = null
}

variable "content_type_profile_config" {
  description = "Content Type Profile Config specifies when to forward content if a content type isn't recognized and profiles to use as by default in a request if a query argument doesn't specify a profile to use"
  type = object({
    forward_when_content_type_is_unknown = bool
    content_type_profiles = object({
      items = list(object({
        content_type = string
        format       = string
        profile_id   = optional(string)
      }))
    })
  })

  validation {
    condition = alltrue([
      for item in var.content_type_profile_config.content_type_profiles.items :
      item.content_type == "application/x-www-form-urlencoded"
    ])
    error_message = "resource_aws_cloudfront_field_level_encryption_config, content_type must be 'application/x-www-form-urlencoded'."
  }

  validation {
    condition = alltrue([
      for item in var.content_type_profile_config.content_type_profiles.items :
      item.format == "URLEncoded"
    ])
    error_message = "resource_aws_cloudfront_field_level_encryption_config, format must be 'URLEncoded'."
  }
}

variable "query_arg_profile_config" {
  description = "Query Arg Profile Config that specifies when to forward content if a profile isn't found and the profile that can be provided as a query argument in a request"
  type = object({
    forward_when_query_arg_profile_is_unknown = bool
    query_arg_profiles = optional(object({
      items = list(object({
        profile_id = string
        query_arg  = string
      }))
    }))
  })
}