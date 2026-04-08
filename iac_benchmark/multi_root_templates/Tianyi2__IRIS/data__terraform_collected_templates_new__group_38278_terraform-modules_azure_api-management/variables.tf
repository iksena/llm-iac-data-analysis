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

##############################################
#     Azure API Management Configuration     #
##############################################
variable "publisher_name" {
  description = "(Required) Name of the publisher for the API Management service"
  type        = string
}

variable "publisher_email" {
  description = "(Required) Email of the publisher for the API Management service"
  type        = string
}

variable "sku_name" {
  description = "(Required) sku_name is a string consisting of two parts separated by an underscore(_). The first part is the name, valid values include: Consumption, Developer, Basic, Standard and Premium. The second part is the capacity (e.g. the number of deployed units of the sku), which must be a positive integer (e.g. Developer_1)."
  type        = string
}

variable "public_network_access_enabled" {
  description = "(Optional) Is public access to the service allowed? Defaults to true."
  type        = bool
}

variable "apis" {
  type = map(object({
    api_name                  = string
    revision                  = string
    display_name              = string
    path                      = string
    protocols                 = list(string)
    content_format            = string
    content_value             = string
    identifier                = string
    sampling_percentage       = number
    always_log_errors         = bool
    log_client_ip             = bool
    verbosity                 = string
    http_correlation_protocol = string
    frontend_request = object({
      body_bytes     = number
      headers_to_log = list(string)
    })
    frontend_response = object({
      body_bytes     = number
      headers_to_log = list(string)
    })
    backend_request = object({
      body_bytes     = number
      headers_to_log = list(string)
    })
    backend_response = object({
      body_bytes     = number
      headers_to_log = list(string)
    })
  }))
}

######################################
#     Azure Application Insights     #
######################################
variable "application_insights_type" {
  description = "(Optional) Type of the Application Insights resource"
  type        = string
  default     = "other"
}

############################
#     Azure Networking     #
############################
variable "subnet_id" {
  description = "(Required) The id of the subnet that will be used for the API Management."
  type        = string
}
