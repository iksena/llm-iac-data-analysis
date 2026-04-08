variable "region" {
  description = "The AWS region to launch the resources."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "valerii-vasianovych.online"
}

variable "acl" {
  description = "The ACL for the S3 bucket."
  type        = string
  default     = "public-read"
}

variable "path_pages" {
  description = "The path to the static files to be uploaded to the S3 bucket."
  type        = string
  default     = "pages"
}

variable "zone_id" {
  description = "The Route 53 zone ID."
  type        = string
  default     = "Z3AQBSTGFYJSTF"
}