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

variable "vultr_api_key" {
  description = "An API key for accessing Vultr services."
  type        = string
  sensitive   = true
  nullable    = false
}

variable "vultr_instance_plan" {
  description = "The Vultr plan ID for cloud servers. See https://api.vultr.com/v2/plans"
  type        = string
  nullable    = false
  default     = "vhp-2c-2gb-amd"
}

variable "vultr_instance_region" {
  description = "The Vultr region ID for cloud servers. See https://api.vultr.com/v2/regions"
  type        = string
  nullable    = false
  default     = "fra"
}

variable "vultr_instance_os" {
  description = "The Vultr OS ID for cloud servers. See https://api.vultr.com/v2/os"
  type        = number
  nullable    = false
  default     = 477
}

variable "vpn_settings" {
  description = "The VPN settings for V2Ray server."
  type = object({
    name = string
    port = number
  })
  default = {
    name = "vmess-ws"
    port = 8080
  }
}
