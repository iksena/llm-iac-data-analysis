variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "service_identifier" {
  description = "The ID or Amazon Resource Identifier (ARN) of the service."
  type        = string

  validation {
    condition     = can(regex("^(arn:aws[a-zA-Z-]*:vpc-lattice:[a-z0-9-]+:[0-9]{12}:service/svc-[0-9a-z]{17}|svc-[0-9a-z]{17})$", var.service_identifier))
    error_message = "resource_aws_vpclattice_service_network_service_association, service_identifier must be a valid service ID (svc-*) or ARN."
  }
}

variable "service_network_identifier" {
  description = "The ID or Amazon Resource Identifier (ARN) of the service network. You must use the ARN if the resources specified in the operation are in different accounts."
  type        = string

  validation {
    condition     = can(regex("^(arn:aws[a-zA-Z-]*:vpc-lattice:[a-z0-9-]+:[0-9]{12}:servicenetwork/sn-[0-9a-z]{17}|sn-[0-9a-z]{17})$", var.service_network_identifier))
    error_message = "resource_aws_vpclattice_service_network_service_association, service_network_identifier must be a valid service network ID (sn-*) or ARN."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_vpclattice_service_network_service_association, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_vpclattice_service_network_service_association, tags values must be between 0 and 256 characters."
  }
}