variable "content" {
  type        = string
  description = "Content for the resource policy. The text must be correctly formatted JSON that complies with the syntax for the resource policy's type."

  validation {
    condition     = can(jsondecode(var.content))
    error_message = "resource_aws_organizations_resource_policy, content must be valid JSON."
  }
}

variable "tags" {
  type        = map(string)
  description = "Key-value map of resource tags."
  default     = {}
}