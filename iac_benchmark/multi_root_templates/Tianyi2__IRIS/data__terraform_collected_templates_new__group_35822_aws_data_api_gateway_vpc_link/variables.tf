variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the API Gateway VPC Link to look up. If no API Gateway VPC Link is found with this name, an error will be returned. If multiple API Gateway VPC Links are found with this name, an error will be returned."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_api_gateway_vpc_link, name must not be empty."
  }
}