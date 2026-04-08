variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "index_id" {
  description = "Identifier of the index that contains the block list."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.index_id))
    error_message = "data_aws_kendra_query_suggestions_block_list, index_id must be a valid UUID format."
  }
}

variable "query_suggestions_block_list_id" {
  description = "Identifier of the block list."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.query_suggestions_block_list_id))
    error_message = "data_aws_kendra_query_suggestions_block_list, query_suggestions_block_list_id must be a valid UUID format."
  }
}