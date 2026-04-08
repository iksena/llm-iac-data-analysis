variable "name" {
  description = "The name of a budget. Unique within accounts."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "data_budgets_budget, name must not be empty"
  }
}

variable "account_id" {
  description = "The ID of the target account for budget. Will use current user's account_id by default if omitted."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "The prefix of the name of a budget. Unique within accounts."
  type        = string
  default     = null
}