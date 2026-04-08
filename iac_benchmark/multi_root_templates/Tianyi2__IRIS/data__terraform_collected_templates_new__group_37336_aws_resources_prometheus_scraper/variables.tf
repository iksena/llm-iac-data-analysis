variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "alias" {
  description = "A name to associate with the managed scraper. This is for your use, and does not need to be unique."
  type        = string
  default     = null
}

variable "scrape_configuration" {
  description = "The configuration file to use in the new scraper."
  type        = string

  validation {
    condition     = var.scrape_configuration != null && var.scrape_configuration != ""
    error_message = "resource_aws_prometheus_scraper, scrape_configuration must be provided and cannot be empty."
  }
}

variable "destination_amp_workspace_arn" {
  description = "The Amazon Resource Name (ARN) of the prometheus workspace."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:aps:[a-z0-9-]+:[0-9]+:workspace/ws-[a-zA-Z0-9-]+$", var.destination_amp_workspace_arn))
    error_message = "resource_aws_prometheus_scraper, destination_amp_workspace_arn must be a valid Prometheus workspace ARN."
  }
}

variable "source_eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the source EKS cluster."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:eks:[a-z0-9-]+:[0-9]+:cluster/[a-zA-Z0-9-_]+$", var.source_eks_cluster_arn))
    error_message = "resource_aws_prometheus_scraper, source_eks_cluster_arn must be a valid EKS cluster ARN."
  }
}

variable "source_eks_subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones."
  type        = list(string)

  validation {
    condition     = length(var.source_eks_subnet_ids) >= 2
    error_message = "resource_aws_prometheus_scraper, source_eks_subnet_ids must contain at least 2 subnet IDs."
  }

  validation {
    condition     = alltrue([for id in var.source_eks_subnet_ids : can(regex("^subnet-[a-zA-Z0-9]+$", id))])
    error_message = "resource_aws_prometheus_scraper, source_eks_subnet_ids must contain valid subnet IDs."
  }
}

variable "source_eks_security_group_ids" {
  description = "List of the security group IDs for the Amazon EKS cluster VPC configuration."
  type        = list(string)
  default     = null

  validation {
    condition = var.source_eks_security_group_ids == null || alltrue([
      for id in var.source_eks_security_group_ids : can(regex("^sg-[a-zA-Z0-9]+$", id))
    ])
    error_message = "resource_aws_prometheus_scraper, source_eks_security_group_ids must contain valid security group IDs."
  }
}

variable "role_configuration" {
  description = "Configuration block to enable writing to an Amazon Managed Service for Prometheus workspace in a different account."
  type = object({
    source_role_arn = string
    target_role_arn = string
  })
  default = null

  validation {
    condition = var.role_configuration == null || (
      can(regex("^arn:aws:iam::[0-9]+:role/[a-zA-Z0-9+=,.@_-]+$", var.role_configuration.source_role_arn)) &&
      can(regex("^arn:aws:iam::[0-9]+:role/[a-zA-Z0-9+=,.@_-]+$", var.role_configuration.target_role_arn))
    )
    error_message = "resource_aws_prometheus_scraper, role_configuration source_role_arn and target_role_arn must be valid IAM role ARNs."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_prometheus_scraper, timeouts_create must be a valid timeout format (e.g., '30m', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "2m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_prometheus_scraper, timeouts_update must be a valid timeout format (e.g., '2m', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_prometheus_scraper, timeouts_delete must be a valid timeout format (e.g., '20m', '1h')."
  }
}