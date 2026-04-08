variable "topic_name" {
  type = string
}

variable "subscription_account_no" {
  type = number
}

variable "tags" {
  type        = map(string)
  description = "A map of key, value pairs to be added to resources as tags"
  default     = {}
}