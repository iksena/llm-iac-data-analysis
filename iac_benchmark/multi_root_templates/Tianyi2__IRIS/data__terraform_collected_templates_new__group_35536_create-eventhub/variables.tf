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

variable "eventhub_name" {
  type = string
}

variable "eventhub_capacity" {
  type = number
}

variable "location" {
  type = string
}

variable "tenant_resource_group" {
  type = string
}

variable "private_dns_zone_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "kubernetes_resource_group" {
  type = string
}

variable "public_network_access_enabled" {
  type = bool
}