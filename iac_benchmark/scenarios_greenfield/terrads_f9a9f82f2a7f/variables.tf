#
# config/backend.config
#
#================================#
# Terraform AWS Backend Settings #
#================================#
variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "profile" {
  type        = string
  description = "AWS Profile (required by the backend but also used for other resources)"
  default     = "unused"
}

variable "bucket" {
  type        = string
  description = "AWS S3 TF State Backend Bucket"
  default     = "unused"
}
variable "dynamodb_table" {
  type        = string
  description = "AWS DynamoDB TF Lock state table name"
  default     = "unused"
}
variable "encrypt" {
  type        = bool
  description = "Enable AWS DynamoDB with server side encryption"
  default     = true
}

#
# config/base.config
#
#=============================#
# Project Variables           #
#=============================#
variable "project" {
  type        = string
  description = "Project Name"
  default     = "benchmark"
}

variable "project_long" {
  type        = string
  description = "Project Long Name"
  default     = "benchmark-project"
}

variable "environment" {
  type        = string
  description = "Environment Name"
  default     = "dev"
}

#
# config/extra.config
#
#=============================#
# Accounts & Extra Vars       #
#=============================#
variable "region_secondary" {
  type        = string
  description = "AWS Scondary Region for HA"
  default     = "us-west-2"
}
