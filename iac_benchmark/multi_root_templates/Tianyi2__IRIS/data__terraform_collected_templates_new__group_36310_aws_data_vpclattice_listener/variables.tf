variable "service_identifier" {
  description = "ID or Amazon Resource Name (ARN) of the service network"
  type        = string

  validation {
    condition     = can(regex("^(arn:aws:vpc-lattice:[a-z0-9-]+:[0-9]{12}:service/svc-[a-z0-9]{17}|svc-[a-z0-9]{17})$", var.service_identifier))
    error_message = "data_aws_vpclattice_listener, service_identifier must be a valid VPC Lattice service ID (svc-*) or ARN."
  }
}

variable "listener_identifier" {
  description = "ID or Amazon Resource Name (ARN) of the listener"
  type        = string

  validation {
    condition     = can(regex("^(arn:aws:vpc-lattice:[a-z0-9-]+:[0-9]{12}:service/svc-[a-z0-9]{17}/listener/listener-[a-z0-9]{17}|listener-[a-z0-9]{17})$", var.listener_identifier))
    error_message = "data_aws_vpclattice_listener, listener_identifier must be a valid VPC Lattice listener ID (listener-*) or ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_vpclattice_listener, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}