variable "container" {
  description = "Set of configuration blocks that describe the settings of the containers that will be launched on the container service. Maximum of 53."
  type = list(object({
    container_name = string
    image          = string
    command        = optional(list(string))
    environment    = optional(map(string))
    ports          = optional(map(string))
  }))

  validation {
    condition     = length(var.container) <= 53
    error_message = "resource_aws_lightsail_container_service_deployment_version, container: Maximum of 53 containers are allowed."
  }

  validation {
    condition = alltrue([
      for container in var.container : container.container_name != null && container.container_name != ""
    ])
    error_message = "resource_aws_lightsail_container_service_deployment_version, container: container_name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for container in var.container : container.image != null && container.image != ""
    ])
    error_message = "resource_aws_lightsail_container_service_deployment_version, container: image is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for container in var.container :
      container.ports == null || alltrue([
        for port, protocol in container.ports : contains(["HTTP", "HTTPS", "TCP", "UDP"], protocol)
      ])
    ])
    error_message = "resource_aws_lightsail_container_service_deployment_version, container: ports values must be one of HTTP, HTTPS, TCP, UDP."
  }
}

variable "service_name" {
  description = "Name of the container service."
  type        = string

  validation {
    condition     = var.service_name != null && var.service_name != ""
    error_message = "resource_aws_lightsail_container_service_deployment_version, service_name: service_name is required and cannot be empty."
  }
}

variable "public_endpoint" {
  description = "Configuration block that describes the settings of the public endpoint for the container service."
  type = object({
    container_name = string
    container_port = number
    health_check = object({
      healthy_threshold   = optional(number, 2)
      interval_seconds    = optional(number, 5)
      path                = optional(string, "/")
      success_codes       = optional(string, "200-499")
      timeout_seconds     = optional(number, 2)
      unhealthy_threshold = optional(number, 2)
    })
  })
  default = null

  validation {
    condition = var.public_endpoint == null || (
      var.public_endpoint.container_name != null && var.public_endpoint.container_name != ""
    )
    error_message = "resource_aws_lightsail_container_service_deployment_version, public_endpoint: container_name is required and cannot be empty when public_endpoint is specified."
  }

  validation {
    condition = var.public_endpoint == null || (
      var.public_endpoint.container_port != null && var.public_endpoint.container_port > 0
    )
    error_message = "resource_aws_lightsail_container_service_deployment_version, public_endpoint: container_port is required and must be a positive number when public_endpoint is specified."
  }

  validation {
    condition = var.public_endpoint == null || (
      var.public_endpoint.health_check.healthy_threshold >= 1
    )
    error_message = "resource_aws_lightsail_container_service_deployment_version, public_endpoint: healthy_threshold must be at least 1."
  }

  validation {
    condition = var.public_endpoint == null || (
      var.public_endpoint.health_check.interval_seconds >= 5 && var.public_endpoint.health_check.interval_seconds <= 300
    )
    error_message = "resource_aws_lightsail_container_service_deployment_version, public_endpoint: interval_seconds must be between 5 and 300 seconds."
  }

  validation {
    condition = var.public_endpoint == null || (
      var.public_endpoint.health_check.timeout_seconds >= 2 && var.public_endpoint.health_check.timeout_seconds <= 60
    )
    error_message = "resource_aws_lightsail_container_service_deployment_version, public_endpoint: timeout_seconds must be between 2 and 60 seconds."
  }

  validation {
    condition = var.public_endpoint == null || (
      var.public_endpoint.health_check.unhealthy_threshold >= 1
    )
    error_message = "resource_aws_lightsail_container_service_deployment_version, public_endpoint: unhealthy_threshold must be at least 1."
  }

  validation {
    condition = var.public_endpoint == null || (
      can(regex("^[0-9]+-[0-9]+$", var.public_endpoint.health_check.success_codes)) ||
      can(tonumber(var.public_endpoint.health_check.success_codes))
    )
    error_message = "resource_aws_lightsail_container_service_deployment_version, public_endpoint: success_codes must be a valid HTTP status code or range (e.g., '200', '200-499')."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "timeouts_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_create))
    error_message = "resource_aws_lightsail_container_service_deployment_version, timeouts_create: must be a valid duration string (e.g., '30m', '1h', '60s')."
  }
}