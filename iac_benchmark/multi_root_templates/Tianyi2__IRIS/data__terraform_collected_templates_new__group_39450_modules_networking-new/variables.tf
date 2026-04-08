variable "name" {
  type    = string
  default = "root-live"
}

variable "namespace" {
  type    = string
  default = "mdtp"
}

variable "tags" {
  type        = map(string)
  description = "A map of key, value pairs to be added to resources as tags"
  default     = {}
}