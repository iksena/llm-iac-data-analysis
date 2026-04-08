variable "domain" {
  description = "The name of the domain to create. All domain names in an AWS Region that are in the same AWS account must be unique. The domain name is used as the prefix in DNS hostnames. Do not use sensitive information in a domain name because it is publicly discoverable."
  type        = string

  validation {
    condition     = length(var.domain) > 0
    error_message = "resource_aws_codeartifact_domain, domain cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1,2}$", var.region))
    error_message = "resource_aws_codeartifact_domain, region must be a valid AWS region format."
  }
}

variable "encryption_key" {
  description = "The encryption key for the domain. This is used to encrypt content stored in a domain. The KMS Key Amazon Resource Name (ARN). The default aws/codeartifact AWS KMS master key is used if this element is absent."
  type        = string
  default     = null

  validation {
    condition     = var.encryption_key == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.encryption_key)) || can(regex("^alias/.+", var.encryption_key))
    error_message = "resource_aws_codeartifact_domain, encryption_key must be a valid KMS key ARN or alias."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) > 0 && length(v) >= 0])
    error_message = "resource_aws_codeartifact_domain, tags keys cannot be empty."
  }
}