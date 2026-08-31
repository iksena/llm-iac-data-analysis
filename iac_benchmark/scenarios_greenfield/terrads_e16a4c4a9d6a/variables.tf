variable "tags" {
  type = map

  default = {
    Environment = "Terraform"
  }

  description = "Tags."
}

variable "cloudtrail_name" {
  type        = string
  description = "Name of the cloudtrail to be created."
  default     = "benchmark-cloudtrail"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 Bucket to be created."
  default     = "benchmark-cloudtrail-logs-614084726772"
}

variable "namespace" {
  type        = string
  description = "The namespace for the module to use."
  default     = "benchmark"
}

variable "prefix" {
  type        = string
  default     = ""
  description = "Prefix to use for the cloudtrail logs."
}

variable "retention_in_days" {
  type        = number
  default     = 30
  description = "The number of days log events are retained in the log group to be created."
}
