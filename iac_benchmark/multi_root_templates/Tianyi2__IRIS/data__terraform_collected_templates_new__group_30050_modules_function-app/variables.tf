variable "app_service_plan_name" {
    description = "The name of the App Service Plan."
    type = string
}

variable "resource_group_name" {
    description = "The name of the resource group in which to create the resources."
    type = string
}

variable "location" {
    description = "The location/region where the resources will be created."
    type = string  
}

variable "function_app_name" {
    description = "The name of the Function App."
    type = string   
}

variable "event_hub_namespace_name" {
    description = "The name of the Event Hub Namespace."
    type = string  
}

variable "event_hub_namespace_id" {
    description = "The ID of the Event Hub Namespace."
    type = string  
}

variable "event_hub_name" {
    description = "The name of the Event Hub Topic."
    type = string  
}

variable "datadog_api_key" {
    description = "The Datadog API key."
    type = string
    sensitive = true  
}

variable "datadog_site" {
    description = "The Datadog site."
    type = string  
}

variable "storage_account_name" {
    description = "The name of the storage account."
    type = string 
}

variable "storage_account_id" {
    description = "The ID of the storage account."
    type = string   
}

variable "vnet_id" {
    description = "The ID of the virtual network."
    type = string  
}

variable "fa_outbound_subnet_id" {
    description = "The ID of the subnet for vnet integration of the Function App."
    type = string  
}

variable "fa_pep_subnet_id" {
    description = "The ID of the subnet for private endpoint of the Function App."
    type = string  
}
