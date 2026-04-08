variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null
}

variable "base_theme_id" {
  description = "The ID of the theme that a custom theme will inherit from. All themes inherit from one of the starting themes defined by Amazon QuickSight."
  type        = string

  validation {
    condition     = var.base_theme_id != null && var.base_theme_id != ""
    error_message = "resource_aws_quicksight_theme, base_theme_id cannot be null or empty."
  }
}

variable "name" {
  description = "Display name of the theme."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_quicksight_theme, name cannot be null or empty."
  }
}

variable "theme_id" {
  description = "Identifier of the theme."
  type        = string

  validation {
    condition     = var.theme_id != null && var.theme_id != ""
    error_message = "resource_aws_quicksight_theme, theme_id cannot be null or empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null
}

variable "permissions" {
  description = "A set of resource permissions on the theme. Maximum of 64 items."
  type = list(object({
    actions   = list(string)
    principal = string
  }))
  default = null

  validation {
    condition     = var.permissions == null || length(var.permissions) <= 64
    error_message = "resource_aws_quicksight_theme, permissions cannot exceed 64 items."
  }

  validation {
    condition = var.permissions == null || alltrue([
      for permission in var.permissions :
      permission.actions != null && length(permission.actions) > 0 && permission.principal != null && permission.principal != ""
    ])
    error_message = "resource_aws_quicksight_theme, permissions each permission must have non-empty actions list and non-empty principal."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "version_description" {
  description = "A description of the current theme version being created/updated."
  type        = string
  default     = null
}

variable "configuration" {
  description = "The theme configuration, which contains the theme display properties."
  type = object({
    data_color_palette = optional(object({
      colors           = optional(list(string))
      empty_fill_color = optional(string)
      min_max_gradient = optional(list(string))
    }))
    sheet = optional(object({
      tile = optional(object({
        border = optional(object({
          show = optional(bool)
        }))
      }))
      tile_layout = optional(object({
        gutter = optional(object({
          show = optional(bool)
        }))
        margin = optional(object({
          show = optional(bool)
        }))
      }))
    }))
    typography = optional(object({
      font_families = optional(list(object({
        font_family = optional(string)
      })))
    }))
    ui_color_palette = optional(object({
      accent               = optional(string)
      accent_foreground    = optional(string)
      danger               = optional(string)
      danger_foreground    = optional(string)
      dimension            = optional(string)
      dimension_foreground = optional(string)
      measure              = optional(string)
      measure_foreground   = optional(string)
      primary_background   = optional(string)
      primary_foreground   = optional(string)
      secondary_background = optional(string)
      secondary_foreground = optional(string)
      success              = optional(string)
      success_foreground   = optional(string)
      warning              = optional(string)
      warning_foreground   = optional(string)
    }))
  })

  validation {
    condition     = var.configuration != null
    error_message = "resource_aws_quicksight_theme, configuration is required."
  }

  validation {
    condition = var.configuration.data_color_palette == null || (
      var.configuration.data_color_palette.colors == null || (
        length(var.configuration.data_color_palette.colors) >= 8 &&
        length(var.configuration.data_color_palette.colors) <= 20
      )
    )
    error_message = "resource_aws_quicksight_theme, configuration.data_color_palette.colors must have between 8 and 20 items."
  }

  validation {
    condition = var.configuration.data_color_palette == null || (
      var.configuration.data_color_palette.min_max_gradient == null ||
      length(var.configuration.data_color_palette.min_max_gradient) == 2
    )
    error_message = "resource_aws_quicksight_theme, configuration.data_color_palette.min_max_gradient must have exactly 2 items."
  }

  validation {
    condition = var.configuration.typography == null || (
      var.configuration.typography.font_families == null ||
      length(var.configuration.typography.font_families) <= 5
    )
    error_message = "resource_aws_quicksight_theme, configuration.typography.font_families cannot exceed 5 items."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}