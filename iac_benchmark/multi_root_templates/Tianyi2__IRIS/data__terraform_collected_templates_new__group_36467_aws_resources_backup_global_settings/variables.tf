variable "global_settings" {
  description = "A list of resources along with the opt-in preferences for the account"
  type        = map(string)

  validation {
    condition     = length(var.global_settings) > 0
    error_message = "resource_aws_backup_global_settings, global_settings must not be empty."
  }
}