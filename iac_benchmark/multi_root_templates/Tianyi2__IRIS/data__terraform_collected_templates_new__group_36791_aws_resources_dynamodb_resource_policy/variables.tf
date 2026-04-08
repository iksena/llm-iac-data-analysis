variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the DynamoDB resource to which the policy will be attached. The resources you can specify include tables and streams. You can control index permissions using the base table's policy. To specify the same permission level for your table and its indexes, you can provide both the table and index Amazon Resource Name (ARN)s in the Resource field of a given Statement in your policy document. Alternatively, to specify different permissions for your table, indexes, or both, you can define multiple Statement fields in your policy document."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:dynamodb:", var.resource_arn))
    error_message = "resource_aws_dynamodb_resource_policy, resource_arn must be a valid DynamoDB ARN starting with 'arn:aws:dynamodb:'."
  }
}

variable "policy" {
  description = "An Amazon Web Services resource-based policy document in JSON format. The maximum size supported for a resource-based policy document is 20 KB. DynamoDB counts whitespaces when calculating the size of a policy against this limit. For a full list of all considerations that you should keep in mind while attaching a resource-based policy, see Resource-based policy considerations."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_dynamodb_resource_policy, policy must be a valid JSON string."
  }

  validation {
    condition     = length(var.policy) <= 20480
    error_message = "resource_aws_dynamodb_resource_policy, policy maximum size is 20 KB (20480 bytes)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "confirm_remove_self_resource_access" {
  description = "Set this parameter to true to confirm that you want to remove your permissions to change the policy of this resource in the future."
  type        = bool
  default     = null
}