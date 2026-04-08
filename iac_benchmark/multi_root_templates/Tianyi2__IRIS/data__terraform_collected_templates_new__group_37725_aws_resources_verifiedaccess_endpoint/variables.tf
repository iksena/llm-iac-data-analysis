variable "attachment_type" {
  description = "The type of attachment. Currently, only vpc is supported."
  type        = string

  validation {
    condition     = var.attachment_type == "vpc"
    error_message = "resource_aws_verifiedaccess_endpoint, attachment_type must be 'vpc'."
  }
}

variable "endpoint_domain_prefix" {
  description = "A custom identifier that is prepended to the DNS name that is generated for the endpoint."
  type        = string
}

variable "endpoint_type" {
  description = "The type of Verified Access endpoint to create. Currently load-balancer, network-interface, or cidr are supported."
  type        = string

  validation {
    condition     = contains(["load-balancer", "network-interface", "cidr"], var.endpoint_type)
    error_message = "resource_aws_verifiedaccess_endpoint, endpoint_type must be one of: load-balancer, network-interface, cidr."
  }
}

variable "verified_access_group_id" {
  description = "The ID of the Verified Access group to associate the endpoint with."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_domain" {
  description = "The DNS name for users to reach your application. This parameter is required if the endpoint type is load-balancer or network-interface."
  type        = string
  default     = null
}

variable "description" {
  description = "A description for the Verified Access endpoint."
  type        = string
  default     = null
}

variable "domain_certificate_arn" {
  description = "The ARN of the public TLS/SSL certificate in AWS Certificate Manager to associate with the endpoint. The CN in the certificate must match the DNS name your end users will use to reach your application. This parameter is required if the endpoint type is load-balancer or network-interface."
  type        = string
  default     = null
}

variable "policy_document" {
  description = "The policy document that is associated with this resource."
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of the security groups IDs to associate with the Verified Access endpoint."
  type        = list(string)
  default     = null
}

variable "sse_specification" {
  description = "The options in use for server side encryption."
  type = object({
    customer_managed_key_enabled = optional(bool)
    kms_key_arn                  = optional(string)
  })
  default = null
}

variable "load_balancer_options" {
  description = "The load balancer details. This parameter is required if the endpoint type is load-balancer."
  type = object({
    load_balancer_arn = string
    port              = number
    protocol          = string
    subnet_ids        = list(string)
  })
  default = null

  validation {
    condition = var.load_balancer_options == null || (
      var.load_balancer_options.port >= 1 && var.load_balancer_options.port <= 65535
    )
    error_message = "resource_aws_verifiedaccess_endpoint, load_balancer_options.port must be between 1 and 65535."
  }

  validation {
    condition     = var.load_balancer_options == null || contains(["http", "https"], var.load_balancer_options.protocol)
    error_message = "resource_aws_verifiedaccess_endpoint, load_balancer_options.protocol must be 'http' or 'https'."
  }
}

variable "network_interface_options" {
  description = "The network interface details. This parameter is required if the endpoint type is network-interface."
  type = object({
    network_interface_id = string
    port                 = number
    protocol             = string
  })
  default = null

  validation {
    condition = var.network_interface_options == null || (
      var.network_interface_options.port >= 1 && var.network_interface_options.port <= 65535
    )
    error_message = "resource_aws_verifiedaccess_endpoint, network_interface_options.port must be between 1 and 65535."
  }

  validation {
    condition     = var.network_interface_options == null || contains(["http", "https"], var.network_interface_options.protocol)
    error_message = "resource_aws_verifiedaccess_endpoint, network_interface_options.protocol must be 'http' or 'https'."
  }
}

variable "cidr_options" {
  description = "The CIDR block details. This parameter is required if the endpoint type is cidr."
  type = object({
    cidr       = string
    protocol   = string
    subnet_ids = list(string)
    port_range = optional(object({
      from_port = number
      to_port   = number
    }))
  })
  default = null

  validation {
    condition     = var.cidr_options == null || contains(["tcp", "udp"], var.cidr_options.protocol)
    error_message = "resource_aws_verifiedaccess_endpoint, cidr_options.protocol must be 'tcp' or 'udp'."
  }

  validation {
    condition = var.cidr_options == null || var.cidr_options.port_range == null || (
      var.cidr_options.port_range.from_port >= 1 &&
      var.cidr_options.port_range.from_port <= 65535 &&
      var.cidr_options.port_range.to_port >= 1 &&
      var.cidr_options.port_range.to_port <= 65535 &&
      var.cidr_options.port_range.from_port <= var.cidr_options.port_range.to_port
    )
    error_message = "resource_aws_verifiedaccess_endpoint, cidr_options.port_range from_port and to_port must be between 1 and 65535, and from_port must be <= to_port."
  }
}

variable "tags" {
  description = "Key-value tags for the Verified Access Endpoint. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "60m"
}

variable "timeouts_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "180m"
}

variable "timeouts_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "90m"
}