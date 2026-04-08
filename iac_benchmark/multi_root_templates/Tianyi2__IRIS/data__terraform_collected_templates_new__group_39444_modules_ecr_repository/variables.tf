variable "repository_name" {
  description = "Name of the repository"
}

variable "allow_read_account_id_list" {
  type = list(string)
}

variable "tags" {
  type        = map(string)
  description = "A map of key, value pairs to be added to resources as tags"
  default     = {}
}