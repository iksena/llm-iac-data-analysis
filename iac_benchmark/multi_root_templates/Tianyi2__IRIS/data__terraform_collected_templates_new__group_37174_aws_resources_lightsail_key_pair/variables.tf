variable "name" {
  description = "Name of the Lightsail Key Pair. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || var.name_prefix == null
    error_message = "resource_aws_lightsail_key_pair, name conflicts with name_prefix. Only one can be specified."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "pgp_key" {
  description = "PGP key to encrypt the resulting private key material. Only used when creating a new key pair."
  type        = string
  default     = null
}

variable "public_key" {
  description = "Public key material. This public key will be imported into Lightsail."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. To create a key-only tag, use an empty string as the value."
  type        = map(string)
  default     = {}
}