variable "default-region" {
  type        = string
  description = "Default region for resources will be created"
  default     = "us-east-1"
}

variable "profile" {
  type        = string
  description = "Profile name configured before running apply"
  default     = "unused"
}