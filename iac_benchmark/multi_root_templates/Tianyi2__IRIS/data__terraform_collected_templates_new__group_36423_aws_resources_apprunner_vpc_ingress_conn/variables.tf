variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A name for the VPC Ingress Connection resource. It must be unique across all the active VPC Ingress Connections in your AWS account in the AWS Region."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.name)) && length(var.name) > 0
    error_message = "resource_aws_apprunner_vpc_ingress_connection, name must be a non-empty string containing only alphanumeric characters, hyphens, and underscores."
  }
}

variable "service_arn" {
  description = "The Amazon Resource Name (ARN) for this App Runner service that is used to create the VPC Ingress Connection resource."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:apprunner:[a-z0-9-]+:[0-9]{12}:service/.+", var.service_arn))
    error_message = "resource_aws_apprunner_vpc_ingress_connection, service_arn must be a valid App Runner service ARN."
  }
}

variable "ingress_vpc_configuration" {
  description = "Specifications for the customer's Amazon VPC and the related AWS PrivateLink VPC endpoint that are used to create the VPC Ingress Connection resource."
  type = object({
    vpc_id          = string
    vpc_endpoint_id = string
  })

  validation {
    condition     = can(regex("^vpc-[a-z0-9]{8,17}$", var.ingress_vpc_configuration.vpc_id))
    error_message = "resource_aws_apprunner_vpc_ingress_connection, ingress_vpc_configuration.vpc_id must be a valid VPC ID."
  }

  validation {
    condition     = can(regex("^vpce-[a-z0-9]{8,17}$", var.ingress_vpc_configuration.vpc_endpoint_id))
    error_message = "resource_aws_apprunner_vpc_ingress_connection, ingress_vpc_configuration.vpc_endpoint_id must be a valid VPC endpoint ID."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}