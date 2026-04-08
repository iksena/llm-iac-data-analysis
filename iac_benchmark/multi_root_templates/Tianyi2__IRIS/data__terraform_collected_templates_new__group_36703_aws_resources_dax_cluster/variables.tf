variable "cluster_name" {
  description = "Group identifier. DAX converts this name to lowercase"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.cluster_name))
    error_message = "resource_aws_dax_cluster, cluster_name must contain only alphanumeric characters and hyphens."
  }
}

variable "iam_role_arn" {
  description = "A valid Amazon Resource Name (ARN) that identifies an IAM role. At runtime, DAX will assume this role and use the role's permissions to access DynamoDB on your behalf"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.iam_role_arn))
    error_message = "resource_aws_dax_cluster, iam_role_arn must be a valid IAM role ARN."
  }
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes"
  type        = string

  validation {
    condition = contains([
      "dax.t2.small", "dax.t2.medium", "dax.r4.large", "dax.r4.xlarge",
      "dax.r4.2xlarge", "dax.r4.4xlarge", "dax.r4.8xlarge", "dax.r4.16xlarge",
      "dax.r5.large", "dax.r5.xlarge", "dax.r5.2xlarge", "dax.r5.4xlarge",
      "dax.r5.12xlarge", "dax.r5.24xlarge"
    ], var.node_type)
    error_message = "resource_aws_dax_cluster, node_type must be a valid DAX node type."
  }
}

variable "replication_factor" {
  description = "The number of nodes in the DAX cluster. A replication factor of 1 will create a single-node cluster, without any read replicas"
  type        = number

  validation {
    condition     = var.replication_factor >= 1 && var.replication_factor <= 10
    error_message = "resource_aws_dax_cluster, replication_factor must be between 1 and 10."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_dax_cluster, region must be a valid AWS region identifier."
  }
}

variable "cluster_endpoint_encryption_type" {
  description = "The type of encryption the cluster's endpoint should support. Valid values are: NONE and TLS"
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "TLS"], var.cluster_endpoint_encryption_type)
    error_message = "resource_aws_dax_cluster, cluster_endpoint_encryption_type must be either 'NONE' or 'TLS'."
  }
}

variable "availability_zones" {
  description = "List of Availability Zones in which the nodes will be created"
  type        = list(string)
  default     = null

  validation {
    condition     = var.availability_zones == null || length(var.availability_zones) > 0
    error_message = "resource_aws_dax_cluster, availability_zones must not be empty if specified."
  }
}

variable "description" {
  description = "Description for the cluster"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 255
    error_message = "resource_aws_dax_cluster, description must be 255 characters or less."
  }
}

variable "notification_topic_arn" {
  description = "An Amazon Resource Name (ARN) of an SNS topic to send DAX notifications to"
  type        = string
  default     = null

  validation {
    condition     = var.notification_topic_arn == null || can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:.+", var.notification_topic_arn))
    error_message = "resource_aws_dax_cluster, notification_topic_arn must be a valid SNS topic ARN."
  }
}

variable "parameter_group_name" {
  description = "Name of the parameter group to associate with this DAX cluster"
  type        = string
  default     = null

  validation {
    condition     = var.parameter_group_name == null || can(regex("^[a-zA-Z0-9-]+$", var.parameter_group_name))
    error_message = "resource_aws_dax_cluster, parameter_group_name must contain only alphanumeric characters and hyphens."
  }
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC)"
  type        = string
  default     = null

  validation {
    condition     = var.maintenance_window == null || can(regex("^(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]-(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]$", var.maintenance_window))
    error_message = "resource_aws_dax_cluster, maintenance_window must be in format ddd:hh24:mi-ddd:hh24:mi."
  }
}

variable "security_group_ids" {
  description = "One or more VPC security groups associated with the cluster"
  type        = list(string)
  default     = null

  validation {
    condition     = var.security_group_ids == null || length(var.security_group_ids) > 0
    error_message = "resource_aws_dax_cluster, security_group_ids must not be empty if specified."
  }
}

variable "subnet_group_name" {
  description = "Name of the subnet group to be used for the cluster"
  type        = string
  default     = null

  validation {
    condition     = var.subnet_group_name == null || can(regex("^[a-zA-Z0-9-]+$", var.subnet_group_name))
    error_message = "resource_aws_dax_cluster, subnet_group_name must contain only alphanumeric characters and hyphens."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "server_side_encryption" {
  description = "Encrypt at rest options"
  type = object({
    enabled = optional(bool, false)
  })
  default = null
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "45m")
    update = optional(string, "45m")
    delete = optional(string, "90m")
  })
  default = {
    create = "45m"
    update = "45m"
    delete = "90m"
  }
}