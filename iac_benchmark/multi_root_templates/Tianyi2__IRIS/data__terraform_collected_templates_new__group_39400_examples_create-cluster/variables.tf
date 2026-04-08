// region azure/aks

variable "location" {
  type        = string
  description = "The Azure region where the Resource Group should exist"
}

variable "resource_group_name" {
  type        = string
  description = "The Resource Group name to be imported"
}

variable "prefix" {
  type        = string
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

// endregion

// region spotinst/ocean-aks

variable "spotinst_token" {
  type        = string
  description = "Spot Personal Access token"
}

variable "spotinst_account" {
  type        = string
  description = "Spot account ID"
}

// endregion
