variable "id" {
  description = "Concatenation of the catalog ID and connection name. For example, if your account ID is 123456789123 and the connection name is conn then the ID is 123456789123:conn."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}:.+$", var.id))
    error_message = "data_aws_glue_connection, id must be in the format 'account_id:connection_name' where account_id is a 12-digit AWS account ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_glue_connection, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}