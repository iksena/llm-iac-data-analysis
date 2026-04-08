variable "region" {
  description = "Region variable"
  type        = string
  default     = "us-east-1"
}

variable "users" {
  description = "List of users to create"
  type        = list(string)
  default     = ["bob", "fred", "anna", "andrew", "victor", "samara"]
}