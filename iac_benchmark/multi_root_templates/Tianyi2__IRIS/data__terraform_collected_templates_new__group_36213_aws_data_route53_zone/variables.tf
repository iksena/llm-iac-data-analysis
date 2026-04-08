variable "zone_id" {
  description = "Hosted Zone id of the desired Hosted Zone"
  type        = string
  default     = null
}

variable "name" {
  description = "Hosted Zone name of the desired Hosted Zone"
  type        = string
  default     = null
}

variable "private_zone" {
  description = "Used with name field to get a private Hosted Zone"
  type        = bool
  default     = null
}

variable "vpc_id" {
  description = "Used with name field to get a private Hosted Zone associated with the vpc_id"
  type        = string
  default     = null
}

variable "tags" {
  description = "Used with name field. A map of tags, each pair of which must exactly match a pair on the desired Hosted Zone"
  type        = map(string)
  default     = null
}

