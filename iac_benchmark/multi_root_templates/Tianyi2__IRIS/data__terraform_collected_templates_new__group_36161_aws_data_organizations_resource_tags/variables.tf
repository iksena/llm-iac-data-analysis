variable "resource_id" {
  description = "ID of the resource with the tags to list. Can be AWS account ID, OU ID (ou-*), root ID (r-*), or policy ID (p-*)."
  type        = string

  validation {
    condition     = can(regex("^(\\d{12}|ou-[a-z0-9]{4}-[a-z0-9]{8}|r-[a-z0-9]{4}|p-[a-z0-9]{8})$", var.resource_id))
    error_message = "data_aws_organizations_resource_tags, resource_id must be a valid AWS account ID (12 digits), OU ID (ou-*), root ID (r-*), or policy ID (p-*)."
  }
}