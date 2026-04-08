variable "member_account_discount_visibility" {
  description = "Customize whether the member accounts can see the After Discounts savings estimates"
  type        = string
  default     = "All"

  validation {
    condition     = contains(["All", "None"], var.member_account_discount_visibility)
    error_message = "resource_aws_costoptimizationhub_preferences, member_account_discount_visibility must be one of: All, None."
  }
}

variable "savings_estimation_mode" {
  description = "Customize how estimated monthly savings are calculated"
  type        = string
  default     = "BeforeDiscounts"

  validation {
    condition     = contains(["BeforeDiscounts", "AfterDiscounts"], var.savings_estimation_mode)
    error_message = "resource_aws_costoptimizationhub_preferences, savings_estimation_mode must be one of: BeforeDiscounts, AfterDiscounts."
  }
}