variable "step_name" {
  type = string
}

variable "policy_arns" {
  type = list(string)
}

variable "tags" {
  type        = map(string)
  description = "A map of key, value pairs to be added to resources as tags"
  default     = {}
}