variable "name" {
  description = "Name of the Lightsail load balancer"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_lightsail_lb, name must be a non-empty string."
  }
}

variable "instance_port" {
  description = "Instance port the load balancer will connect to"
  type        = number

  validation {
    condition     = var.instance_port >= 1 && var.instance_port <= 65535
    error_message = "resource_aws_lightsail_lb, instance_port must be a valid port number between 1 and 65535."
  }
}

variable "health_check_path" {
  description = "Health check path of the load balancer"
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/", var.health_check_path))
    error_message = "resource_aws_lightsail_lb, health_check_path must start with a forward slash (/)."
  }
}

variable "ip_address_type" {
  description = "IP address type of the load balancer"
  type        = string
  default     = "dualstack"

  validation {
    condition     = contains(["dualstack", "ipv4"], var.ip_address_type)
    error_message = "resource_aws_lightsail_lb, ip_address_type must be either 'dualstack' or 'ipv4'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_lightsail_lb, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_lightsail_lb, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_lightsail_lb, tags values must be between 0 and 256 characters."
  }
}