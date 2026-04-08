variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "allocation_id" {
  description = "ID of the associated Elastic IP"
  type        = string
  default     = null

  validation {
    condition     = var.allocation_id != null
    error_message = "resource_aws_eip_association, allocation_id is required despite being optional at the resource level due to legacy support for EC2-Classic networking."
  }
}

variable "allow_reassociation" {
  description = "Whether to allow an Elastic IP address to be re-associated"
  type        = bool
  default     = true
}

variable "instance_id" {
  description = "ID of the instance. The instance must have exactly one attached network interface. You can specify either the instance ID or the network interface ID, but not both"
  type        = string
  default     = null
}

variable "network_interface_id" {
  description = "ID of the network interface. If the instance has more than one network interface, you must specify a network interface ID. You can specify either the instance ID or the network interface ID, but not both"
  type        = string
  default     = null
}

variable "private_ip_address" {
  description = "Primary or secondary private IP address to associate with the Elastic IP address. If no private IP address is specified, the Elastic IP address is associated with the primary private IP address"
  type        = string
  default     = null
}

variable "public_ip" {
  description = "Address of the associated Elastic IP (Deprecated since EC2-Classic networking has retired)"
  type        = string
  default     = null
}