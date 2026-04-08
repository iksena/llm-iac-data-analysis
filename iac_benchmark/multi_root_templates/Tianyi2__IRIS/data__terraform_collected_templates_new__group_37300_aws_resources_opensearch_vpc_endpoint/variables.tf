variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_arn" {
  description = "Specifies the Amazon Resource Name (ARN) of the domain to create the endpoint for"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:es:[a-z0-9-]+:[0-9]{12}:domain/[a-zA-Z0-9-]+$", var.domain_arn))
    error_message = "resource_aws_opensearch_vpc_endpoint, domain_arn must be a valid OpenSearch domain ARN."
  }
}

variable "vpc_options_security_group_ids" {
  description = "The list of security group IDs associated with the VPC endpoints for the domain. If you do not provide a security group ID, OpenSearch Service uses the default security group for the VPC."
  type        = list(string)
  default     = null

  validation {
    condition = var.vpc_options_security_group_ids == null || (
      length(var.vpc_options_security_group_ids) > 0 &&
      alltrue([for id in var.vpc_options_security_group_ids : can(regex("^sg-[a-z0-9]+$", id))])
    )
    error_message = "resource_aws_opensearch_vpc_endpoint, vpc_options_security_group_ids must be a list of valid security group IDs starting with 'sg-'."
  }
}

variable "vpc_options_subnet_ids" {
  description = "A list of subnet IDs associated with the VPC endpoints for the domain. If your domain uses multiple Availability Zones, you need to provide two subnet IDs, one per zone. Otherwise, provide only one."
  type        = list(string)

  validation {
    condition     = length(var.vpc_options_subnet_ids) > 0 && length(var.vpc_options_subnet_ids) <= 2
    error_message = "resource_aws_opensearch_vpc_endpoint, vpc_options_subnet_ids must contain between 1 and 2 subnet IDs."
  }

  validation {
    condition     = alltrue([for id in var.vpc_options_subnet_ids : can(regex("^subnet-[a-z0-9]+$", id))])
    error_message = "resource_aws_opensearch_vpc_endpoint, vpc_options_subnet_ids must be a list of valid subnet IDs starting with 'subnet-'."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the OpenSearch VPC endpoint"
  type        = string
  default     = "60m"

  validation {
    condition     = can(regex("^[0-9]+[smhd]$", var.timeouts_create))
    error_message = "resource_aws_opensearch_vpc_endpoint, timeouts_create must be a valid timeout format (e.g., '60m', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for updating the OpenSearch VPC endpoint"
  type        = string
  default     = "60m"

  validation {
    condition     = can(regex("^[0-9]+[smhd]$", var.timeouts_update))
    error_message = "resource_aws_opensearch_vpc_endpoint, timeouts_update must be a valid timeout format (e.g., '60m', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the OpenSearch VPC endpoint"
  type        = string
  default     = "90m"

  validation {
    condition     = can(regex("^[0-9]+[smhd]$", var.timeouts_delete))
    error_message = "resource_aws_opensearch_vpc_endpoint, timeouts_delete must be a valid timeout format (e.g., '90m', '1h')."
  }
}