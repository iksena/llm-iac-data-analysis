variable "buckets_prefix" {
  type        = string
  description = "Prefix for bucket names"
  default     = "benchmark-"
}

variable "buckets_suffix" {
  type        = string
  description = "Suffix for bucket names"
  default     = "-tf5"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags"
  default     = {}
}

variable "cloudtrail_name" {
  type        = string
  description = "Name of CloudTrail trail"
  default     = "benchmark-trail"
}

variable "enable_logging" {
  type        = bool
  description = "Whether to enable CloudTrail"
  default     = true
}
