# https://developer.hashicorp.com/terraform/language/values/variables
# https://developer.hashicorp.com/terraform/language/expressions/type-constraints

variable "name" {
  description = "A unique human-readable name for the deployment."
  type        = string
  nullable    = false
}

variable "domain" {
  description = "A domain name for the deployment."
  type        = string
  nullable    = false
}

variable "acme_email" {
  description = "An email address for registering an account with ACME."
  type        = string
  nullable    = false
}

variable "cloudflare_api_token" {
  description = "An API token for accessing Cloudflare services."
  type        = string
  sensitive   = true
  nullable    = false
}

variable "access_key" {
  description = "An access key for accessing AWS services."
  type        = string
  sensitive   = true
  nullable    = false
}

variable "secret_key" {
  description = "The secret access key for accessing AWS services."
  type        = string
  sensitive   = true
  nullable    = false
}

variable "region" {
  description = "An AWS region to manage deployment resources in."
  type        = string
  nullable    = false
  default     = "me-central-1"
}

variable "instance_type" {
  description = "The AWS EC2 instance type for X-UI server."
  type        = string
  nullable    = false
  default     = "t3.small"
}
