variable "name" {
  description = "Name of the instance profile. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix. Can be a string of characters consisting of upper and lowercase alphanumeric characters and these special characters: _, +, =, ,, ., @, -. Spaces are not allowed. The name must be unique, regardless of the path or role."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9_+=,.@-]+$", var.name))
    error_message = "resource_aws_iam_instance_profile, name must be a string of characters consisting of upper and lowercase alphanumeric characters and these special characters: _, +, =, ,, ., @, -. Spaces are not allowed."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z0-9_+=,.@-]+$", var.name_prefix))
    error_message = "resource_aws_iam_instance_profile, name_prefix must be a string of characters consisting of upper and lowercase alphanumeric characters and these special characters: _, +, =, ,, ., @, -. Spaces are not allowed."
  }
}

variable "path" {
  description = "Path to the instance profile. For more information about paths, see IAM Identifiers in the IAM User Guide. Can be a string of characters consisting of either a forward slash (/) by itself or a string that must begin and end with forward slashes. Can include any ASCII character from the ! (\\u0021) through the DEL character (\\u007F), including most punctuation characters, digits, and upper and lowercase letters."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$", var.path)) || var.path == "/"
    error_message = "resource_aws_iam_instance_profile, path must be either a forward slash (/) by itself or a string that must begin and end with forward slashes."
  }

  validation {
    condition     = can(regex("^[!-~]+$", var.path))
    error_message = "resource_aws_iam_instance_profile, path can only include ASCII characters from ! (\\u0021) through DEL (\\u007F)."
  }
}

variable "role" {
  description = "Name of the role to add to the profile."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of resource tags for the IAM Instance Profile. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}