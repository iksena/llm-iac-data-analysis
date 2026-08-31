#ACCOUNT ID
variable "account_id" {
  type = string
  description = "Account ID, needed for role"
  default     = "000000000000"
}

#Others
variable "region" {
  type        = string
  description = "AWS region where resources will be deployed."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "environment being deployed to"
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnets' CIDR blocks."
  default     = ["10.0.101.0/24","10.0.102.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnets' CIDR blocks."
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "mwaa_max_workers" {
  type        = number
  description = "Maximum number of MWAA workers."
  default     = 2
}

variable "environment_class" {
  type = string
  description = "Machine class for airflow"
  default = "mw1.small"
}

variable "create_buckets" {
  type = bool
  description = "Create more buckets for Data Pipeline"
  default = false
}

variable "bucket_unique_ids" {
  type = list(string)
  description = "Buckets to be Created among pipeline"
  default = []
}

variable "force_destroy" {
  type = bool
  default = true
}

variable "requirements_s3_path" {
  type = string
  default = ""
}