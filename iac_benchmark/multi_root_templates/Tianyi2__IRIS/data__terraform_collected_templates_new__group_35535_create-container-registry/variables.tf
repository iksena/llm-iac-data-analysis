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

variable "container_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "tenant_sp_object_id" {
  type = string
}

variable "deployment_type" {
  type = string
}

variable "admin_enabled" {
  type = bool
}

variable "quarantine_policy_enabled" {
  type = bool
}

variable "data_endpoint_enabled" {
  type = bool
}

variable "public_network_access_enabled" {
  type = bool
}

variable "zone_redundancy_enabled" {
  type = bool
}

variable "trust_policy" {
  type = bool
}

variable "retention_policy_days" {
  type = number
}

variable "kubernetes_tenant_namespace" {
  type = string
}