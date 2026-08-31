variable "name" {
  description = "Api Gateway name"
  default     = "benchmark-api"
}

variable "api_type" {
  default     = "http"

  description = "Type of the API. http or rest"
  type        = string
}

variable "api_description" {
  description = "Description for the API"
  type        = string
  default     = ""
}

variable "open_api_file" {
  description = "Path to the open api specification"
  default     = ""
  type        = string
}

variable "target_arn" {
  description = "Target ARN's to the vpc link"
  default     = ""
  type        = string
}

variable "environment_name" {
  description = "Name of the environment"
  default     = ""
  type        = string
}

variable "domains" {
  description = "Domains to be created for the API GATEWAY"
  default     = []
  type = list(object({
    domain            = string
    api_route_mapping = string
    zone_name         = string
  }))
}

variable "create_dns_record" {
  description = "When enabled, creates the route53 record for the custom domain"
  type        = bool
  default     = true
}

variable "routes" {
  description = "Routes to be created in the API"
  default     = []
  type = list(object({
    name             = string
    method           = string
    integration_type = string
    integration_uri  = string
    route_mapping    = string
    path_parameters  = list(string)
    connection_type  = string
  }))

}

variable "create_vpc_link" {
  description = ""
  type        = bool
  default     = false
}

variable "vpc_link_target_id" {
  description = "ARN of the resource to attach for the VPC link load balancer target"
  type        = string
  default     = ""
}

variable "vpc_link_target_port" {
  description = "TCP Port of the resource to attach for the VPC link load balancer target"
  type        = number
  default     = 443
}

variable "create_api_key" {
  description = "Boolean variable that's evaluate the creation of an api key"
  type        = bool
  default     = false
}

variable "tags" {
  default = {}
}

variable "allowed_ips" {
  description = "List of allowed IP's to access the API"
  type        = list(any)
  default     = []
}

variable "custom_authorizers" {
  description = "Custom authorizer variables"
  default     = []
  type = list(object({
    name                          = string
    custom_authorizer_lambda_code = string
  }))

}
