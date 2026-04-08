variable "existing_rg_name" {
  description = "value for the name of an existing resource group"
  type        = string
  nullable    = false
}

variable "vnet_name" {
  description = "value for the virtual network name"
  type        = string
  nullable    = false
}

variable "vnet_address_space" {
  description = "value for the virtual network address space"
  type        = list(string)
  nullable    = false
}

variable "vnet_dns_servers" {
  description = "value for the virtual network DNS servers"
  type        = list(string)
  nullable    = true
}

variable "subnet_name" {
  description = "value for the subnet name"
  type        = string
}

variable "subnet_address_prefix" {
  description = "value for the subnet address prefix"
  type        = list(string)
}

variable "nsg_name" {
  description = "value for the network security group name"
  type        = string
  nullable    = false
}

variable "rt_name" {
  description = "value for the route table name"
  type        = string
  nullable    = false
}

variable "rt_disable_bgp" {
  description = "value for the route table disable BGP route propagation setting"
  type        = bool
}
