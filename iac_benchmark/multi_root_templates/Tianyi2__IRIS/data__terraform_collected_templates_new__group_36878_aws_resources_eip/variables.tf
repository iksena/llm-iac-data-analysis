variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "address" {
  description = "IP address from an EC2 BYOIP pool. This option is only available for VPC EIPs."
  type        = string
  default     = null
}

variable "associate_with_private_ip" {
  description = "User-specified primary or secondary private IP address to associate with the Elastic IP address. If no private IP address is specified, the Elastic IP address is associated with the primary private IP address."
  type        = string
  default     = null
}

variable "customer_owned_ipv4_pool" {
  description = "ID of a customer-owned address pool. For more on customer owned IP addressed check out Customer-owned IP addresses guide."
  type        = string
  default     = null
}

variable "domain" {
  description = "Indicates if this EIP is for use in VPC (vpc)."
  type        = string
  default     = null

  validation {
    condition     = var.domain == null || var.domain == "vpc"
    error_message = "resource_aws_eip, domain must be 'vpc' or null."
  }
}

variable "instance" {
  description = "EC2 instance ID."
  type        = string
  default     = null

  validation {
    condition     = var.instance == null || can(regex("^i-[0-9a-f]{8,17}$", var.instance))
    error_message = "resource_aws_eip, instance must be a valid EC2 instance ID (i-xxxxxxxx or i-xxxxxxxxxxxxxxxxx) or null."
  }
}

variable "ipam_pool_id" {
  description = "The ID of an IPAM pool which has an Amazon-provided or BYOIP public IPv4 CIDR provisioned to it."
  type        = string
  default     = null

  validation {
    condition     = var.ipam_pool_id == null || can(regex("^ipam-pool-[0-9a-f]{17}$", var.ipam_pool_id))
    error_message = "resource_aws_eip, ipam_pool_id must be a valid IPAM pool ID (ipam-pool-xxxxxxxxxxxxxxxxx) or null."
  }
}

variable "network_border_group" {
  description = "Location from which the IP address is advertised. Use this parameter to limit the address to this location."
  type        = string
  default     = null
}

variable "network_interface" {
  description = "Network interface ID to associate with."
  type        = string
  default     = null

  validation {
    condition     = var.network_interface == null || can(regex("^eni-[0-9a-f]{8,17}$", var.network_interface))
    error_message = "resource_aws_eip, network_interface must be a valid network interface ID (eni-xxxxxxxx or eni-xxxxxxxxxxxxxxxxx) or null."
  }
}

variable "public_ipv4_pool" {
  description = "EC2 IPv4 address pool identifier or 'amazon'. This option is only available for VPC EIPs."
  type        = string
  default     = null

  validation {
    condition     = var.public_ipv4_pool == null || var.public_ipv4_pool == "amazon" || can(regex("^ipv4pool-ec2-[0-9a-f]{6}$", var.public_ipv4_pool))
    error_message = "resource_aws_eip, public_ipv4_pool must be 'amazon', a valid IPv4 pool ID (ipv4pool-ec2-xxxxxx), or null."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. Tags can only be applied to EIPs in a VPC."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration block for setting timeouts for operations"
  type = object({
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null

  validation {
    condition = var.timeouts == null || alltrue([
      for timeout in [var.timeouts.read, var.timeouts.update, var.timeouts.delete] :
      timeout == null || can(regex("^[0-9]+[smh]$", timeout))
    ])
    error_message = "resource_aws_eip, timeouts values must be valid duration strings (e.g., '5m', '15m', '3m') or null."
  }
}