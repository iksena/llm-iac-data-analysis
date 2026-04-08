variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type = string  
}

variable "location" {
    description = "The location/region where the resources will be created."
    type = string  
}

variable "storage_account_name" {
    description = "The name of the storage account."
    type = string  
}

variable "vnet_name" {
    description = "The name of the virtual network."
    type = string  
}

variable "vnet_address_space" {
    description = "The address space of the virtual network."
    type = list(string)  
}

variable "snet_001_name" {
    description = "The name of the subnet for private endpoints."
    type = string  
}

variable "snet_001_prefixes" {
    description = "The address prefixes of the subnet for private endpoints."
    type = list(string)  
}

variable "snet_002_name" {
    description = "The name of the subnet for the Function App."
    type = string  
}

variable "snet_002_prefixes" {
    description = "The address prefixes of the subnet for the Function App."
    type = list(string)  
}
