variable "tenant_id" {
  description = "The tenant id"
  type        = string
}

variable "client_id" {
  description = "The client id"
  type        = string
}

variable "client_secret" {
  description = "The client secret"
  type        = string
}

variable "platform_url" {
  description = "The platform url"
  type        = string
}

variable "identifier_uri" {
  description = "The platform identifier uri"
  type        = string
}

variable "project_stage" {
  description = "The Project stage"
  type        = string
}

variable "project_name" {
  description = "The project name"
  type        = string
}

variable "owner_list" {
  description = "List of mail addresses for App Registration owners"
  type        = list(string)
}

variable "audience" {
  description = "The App Registration audience type"
  type        = string
  validation {
    condition = contains([
      "AzureADMyOrg",
      "AzureADMultipleOrgs"
    ], var.audience)
    error_message = "Only AzureADMyOrg and AzureADMultipleOrgs are supported for audience."
  }
}

variable "location" {
  description = "The Azure location"
}

variable "tenant_resource_group" {
  description = "Resource group to create which will contain created Azure resources for this tenant"
  type        = string
}

variable "dns_record" {
  description = "The DNS zone name to create platform subdomain. Example: myplatform"
  type        = string
}

variable "dns_zone_name" {
  description = "The DNS zone name to create platform subdomain. Example: api.cosmotech.com"
  type        = string
}

variable "virtual_network_address_prefix" {
  description = "The Virtual Network IP range. Minimum /26 NetMaskLength"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "api_version_path" {
  description = "The API version path"
  type        = string
}

variable "customer_name" {
  description = "The customer name"
  type        = string
}

variable "user_app_role" {
  description = "App role for azuread_application"
  type = list(object({
    description  = string
    display_name = string
    id           = string
    role_value   = string
  }))
}

variable "image_path" {
  type = string
}

variable "create_restish" {
  description = "Create the Azure Active Directory Application for Restish"
  type        = bool
}

variable "create_powerbi" {
  description = "Create the Azure Active Directory Application for PowerBI"
  type        = bool
}

variable "create_babylon" {
  description = "Create the Azure Active Directory Application for Babylon"
  type        = bool
}

variable "create_platform" {
  description = "Create the Azure Active Directory Application for Platform"
  type        = bool
}

variable "cost_center" {
  type = string
}

variable "kubernetes_tenant_namespace" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "servlet_context_path" {
  type = string
}

variable "tags" {
  type = map(string)
}