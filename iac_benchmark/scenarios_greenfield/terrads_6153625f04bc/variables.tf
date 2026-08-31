variable "account_id" {
  type        = string
  description = "AWS account id"
  default     = "000000000000"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "benchmark"
}

variable "region" {
  type        = string
  description = "Region terraform will run against"
  default     = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC."
  default     = "benchmark-vpc"
}

variable "deployment_tags" {
  type        = map(string)
  description = "Detault tags for all objects within a deployment (environment) that accept tags"
  default     = {}
}

variable "global_tags" {
  type        = map(string)
  description = "Global tags applied to every resource regardless of deployment"
  default     = {}
}

variable "is_networkhub_vpc" {
  type        = bool
  description = "It the account is the control plane master"
  default     = true
}
