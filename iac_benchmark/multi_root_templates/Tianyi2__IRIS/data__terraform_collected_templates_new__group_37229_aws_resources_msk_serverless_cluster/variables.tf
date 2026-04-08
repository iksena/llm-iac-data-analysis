variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "The name of the serverless cluster."
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "resource_aws_msk_serverless_cluster, cluster_name must not be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "client_authentication" {
  description = "Specifies client authentication information for the serverless cluster."
  type = object({
    sasl = object({
      iam = object({
        enabled = bool
      })
    })
  })

  validation {
    condition     = var.client_authentication != null
    error_message = "resource_aws_msk_serverless_cluster, client_authentication is required."
  }

  validation {
    condition     = var.client_authentication.sasl != null
    error_message = "resource_aws_msk_serverless_cluster, client_authentication.sasl is required."
  }

  validation {
    condition     = var.client_authentication.sasl.iam != null
    error_message = "resource_aws_msk_serverless_cluster, client_authentication.sasl.iam is required."
  }

  validation {
    condition     = can(tobool(var.client_authentication.sasl.iam.enabled))
    error_message = "resource_aws_msk_serverless_cluster, client_authentication.sasl.iam.enabled must be a boolean value."
  }
}

variable "vpc_config" {
  description = "VPC configuration information."
  type = object({
    subnet_ids         = list(string)
    security_group_ids = optional(list(string))
  })

  validation {
    condition     = var.vpc_config != null
    error_message = "resource_aws_msk_serverless_cluster, vpc_config is required."
  }

  validation {
    condition     = length(var.vpc_config.subnet_ids) >= 2
    error_message = "resource_aws_msk_serverless_cluster, vpc_config.subnet_ids must contain at least 2 subnets in different Availability Zones."
  }

  validation {
    condition     = var.vpc_config.security_group_ids == null || length(var.vpc_config.security_group_ids) <= 5
    error_message = "resource_aws_msk_serverless_cluster, vpc_config.security_group_ids can specify up to 5 security groups."
  }
}