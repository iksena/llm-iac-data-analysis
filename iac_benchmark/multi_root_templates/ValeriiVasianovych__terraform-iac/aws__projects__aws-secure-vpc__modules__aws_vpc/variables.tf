# Infrastructure Configuration
variable "region" {
  description = "The AWS region"
  type        = string
  default     = ""
}

variable "env" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = ""
}

# Network Configuration
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIRDR block for the VPC"
  type        = string
  default     = ""
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = []
}

variable "db_private_subnet_cidrs" {
  description = "The CIDR blocks for the database subnets"
  type        = list(string)
  default     = []
}