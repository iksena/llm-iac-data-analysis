variable "tag_key" {
  description = "The key for the cost allocation tag"
  type        = string
}

variable "status" {
  description = "The status of a cost allocation tag"
  type        = string

  validation {
    condition     = contains(["Active", "Inactive"], var.status)
    error_message = "resource_aws_ce_cost_allocation_tag, status must be either 'Active' or 'Inactive'."
  }
}