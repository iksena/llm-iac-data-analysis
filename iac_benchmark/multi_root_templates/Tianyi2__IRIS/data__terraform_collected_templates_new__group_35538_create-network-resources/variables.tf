variable "project_stage" {
  description = "The platform stage"
  type = string
}
variable "customer_name" {
  description = "The customer name"
  type        = string
}
variable "project_name" {
  description = "The project name"
  type        = string
}
variable "cost_center" {
  type    = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be created"
  type        = string
}

variable "tenant_virtual_network_address_prefix" {
  description = "IP range for the virtual network"
  type        = string
}

variable "tenant_virtual_subnet_network_address_prefix" {
  type = string
}

variable "tenant_resource_group" {
  description = "Name of the resource group where the tenant resources will be created"
  type        = string
}

variable "kubernetes_resource_group" {
  description = "Name of the resource group where the platform resources are created"
  type        = string
}

variable "platform_vnet" {
  description = "The platform virtual network"
  type = object({
    id   = string
    name = string
  })
}

variable "networkadt_sp_object_id" {
  description = "The object ID of the network ADT service principal"
  type        = string
}
variable "vnet_resource_group" {
  type = string
}

variable "blob_privatedns_zonename" {
  type = string
}

variable "eventhub_privatedns_zonename" {
  type = string
}