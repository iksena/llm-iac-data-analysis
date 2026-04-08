variable "topic_name" {
  description = "SNS Topic Name"
  type        = string
}

variable "override_policy_json" {
  description = "Override policy document for SNS topic"
  type        = string
  default     = null
}

variable "subscriber_account_numbers" {
  description = "AWS account number of subscribers for cross account access"
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  description = "A map of key, value pairs to be added to resources as tags"
  default     = {}
}