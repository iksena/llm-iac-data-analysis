########################
#    Resource Naming   #
########################
variable "tags" {
  description = "(Required) Tags to be assigned to the resources, must include project, client, owner and environment keys"
  type = object({
    project         = string
    client          = string
    owner           = string
    environment     = string
    additional_tags = optional(map(string))
  })
  nullable = false
}

##########################
#     Resource Group     #
##########################
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which the resources will be created."
  nullable    = false
}

######################################
#     Azure Active Directory B2C     #
######################################
variable "country_code" {
  description = "(Required) Country code of the B2C tenant - Get country code here https://learn.microsoft.com/en-us/azure/active-directory-b2c/data-residency "
  type        = string
}

variable "data_residency_location" {
  description = "(Required) Location in which the B2C tenant is hosted and data resides. Possible values are Asia Pacific, Australia, Europe, Global and United States"
  type        = string
}

variable "b2c_display_name" {
  description = "(Required) Display name of the B2C tenant"
  type        = string
}

variable "b2c_domain_name" {
  description = "(Required) Domain name of the B2C tenant, including the .onmicrosoft.com suffix."
  type        = string
}

variable "b2c_sku" {
  description = "(Required) Billing SKU for the B2C tenant. Must be one of: PremiumP1 or PremiumP2"
  type        = string
}

variable "aadb2c_tags" {
  description = "(Optional) Tags to be assigned to the Azure AD B2C tenant."
  type        = map(string)
  default     = {}
}
