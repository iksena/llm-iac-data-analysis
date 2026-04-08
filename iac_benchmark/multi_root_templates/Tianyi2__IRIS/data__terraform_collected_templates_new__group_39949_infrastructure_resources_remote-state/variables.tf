#############################################################################
# Azure Authenication
#############################################################################

variable "azure_subscription_id" {
	type        = string
	description = "Identifier of the Azure subscription where Terraform should create the configured resources."
}

variable "azure_tenant_id" {
	type        = string
	description = "Identifier of the Azure tenant owning the subscription where Terraform should create the configured resources."
}

variable "azure_client_id" {
	type        = string
	description = "Identifier of the Azure service principal Terraform should use to authenticate with Azure."
}

variable "azure_client_secret" {
	type        = string
	description = "The secret of the Azure service principal Terraform should use to authenticate with Azure."
}

#############################################################################
# Environmental Variables
#############################################################################

variable "azure_region" {
	type        = string
	default     = "northcentralus"
	description = "Location of the resource group."
}

variable "resource_name_environment" {
	type        = string
	description = "The environment component of an Azure resource name. Valid values are dev, qa, e2e, and prod."
}

variable "resource_name_location" {
	type        = string
	description = "The Azure Region component of an Azure resource name. The value must comply with the Abbreviations for Azure Regions standard."
}