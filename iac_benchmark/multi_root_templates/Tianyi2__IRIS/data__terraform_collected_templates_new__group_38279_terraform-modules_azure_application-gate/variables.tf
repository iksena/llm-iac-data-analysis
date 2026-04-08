########################
#    Resource Naming   #
########################
variable "name" {
  description = "The base name of the resources"
  type        = string
}

##########################
#    Resource Group      #
##########################
variable "resource_group" {
  description = "The name of the resource group where resources will be created."
  type        = string
}

##########################
# API Management Service #
##########################
variable "sku_name" {
  description = "The name of the SKU used for the application gateway."
  default     = "Standard_v2"
  type        = string
}

variable "sku_tier" {
  description = "The tier of the SKU used for the application gateway."
  default     = "Standard_v2"
  type        = string
}

variable "sku_capacity" {
  description = "The capacity (instance count) of the SKU used for the application gateway."
  default     = 2
  type        = number
}

variable "subnet_id" {
  description = "The ID of the subnet in which to create the application gateway."
  type        = string
}

variable "frontend_ip_configurations" {
  description = "A list of frontend IP configurations."
  type = list(object({
    name                 = string
    public_ip_address_id = optional(string)
    subnet_id            = optional(string)
  }))
  default = []
}

variable "frontend_ports" {
  description = "A list of frontend ports."
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

variable "http_listeners" {
  description = "A list of HTTP listeners."
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    ssl_certificate_name           = optional(string)
  }))
  default = []
}

variable "backend_address_pools" {
  description = "A list of backend address pools."
  type = list(object({
    name = string
  }))
  default = []
}

variable "backend_http_settings" {
  description = "A list of backend HTTP settings."
  type = list(object({
    name                  = string
    cookie_based_affinity = string
    port                  = number
    protocol              = string
    request_timeout       = number
  }))
  default = []
}

variable "request_routing_rules" {
  description = "A list of request routing rules."
  type = list(object({
    name                       = string
    rule_type                  = string
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
  }))
  default = []
}

variable "waf_configuration" {
  description = "The Web Application Firewall configuration."
  type = object({
    enabled          = bool
    firewall_mode    = string
    rule_set_type    = string
    rule_set_version = string
    rules = list(object({
      name = string
    }))
  })
  default = {
    enabled          = false
    firewall_mode    = "Detection"
    rule_set_type    = "OWASP"
    rule_set_version = "3.0"
    rules            = []
  }
}

########################
#      Tags Config     #
########################
variable "tags" {
  description = "Tags to assign"
  type        = map(string)
}
