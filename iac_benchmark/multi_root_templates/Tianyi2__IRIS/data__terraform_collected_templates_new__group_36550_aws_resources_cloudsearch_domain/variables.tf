variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the CloudSearch domain."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.name)) && length(var.name) >= 1 && length(var.name) <= 64
    error_message = "resource_aws_cloudsearch_domain, name must begin with a lowercase letter, be 1-64 characters long, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "multi_az" {
  description = "Whether or not to maintain extra instances for the domain in a second Availability Zone to ensure high availability."
  type        = bool
  default     = null
}

variable "endpoint_options" {
  description = "Domain endpoint options."
  type = object({
    enforce_https       = optional(bool)
    tls_security_policy = optional(string)
  })
  default = null

  validation {
    condition = var.endpoint_options == null || (
      var.endpoint_options.tls_security_policy == null ||
      contains(["Policy-Min-TLS-1-0-2019-07", "Policy-Min-TLS-1-2-2019-07"], var.endpoint_options.tls_security_policy)
    )
    error_message = "resource_aws_cloudsearch_domain, endpoint_options.tls_security_policy must be one of: Policy-Min-TLS-1-0-2019-07, Policy-Min-TLS-1-2-2019-07."
  }
}

variable "scaling_parameters" {
  description = "Domain scaling parameters."
  type = object({
    desired_instance_type     = optional(string)
    desired_partition_count   = optional(number)
    desired_replication_count = optional(number)
  })
  default = null

  validation {
    condition = var.scaling_parameters == null || (
      var.scaling_parameters.desired_instance_type == null ||
      contains([
        "search.micro", "search.small", "search.medium", "search.large",
        "search.xlarge", "search.2xlarge"
      ], var.scaling_parameters.desired_instance_type)
    )
    error_message = "resource_aws_cloudsearch_domain, scaling_parameters.desired_instance_type must be one of: search.micro, search.small, search.medium, search.large, search.xlarge, search.2xlarge."
  }

  validation {
    condition = var.scaling_parameters == null || (
      var.scaling_parameters.desired_partition_count == null ||
      var.scaling_parameters.desired_instance_type == "search.2xlarge"
    )
    error_message = "resource_aws_cloudsearch_domain, scaling_parameters.desired_partition_count is only valid when desired_instance_type is search.2xlarge."
  }

  validation {
    condition = var.scaling_parameters == null || (
      var.scaling_parameters.desired_partition_count == null ||
      (var.scaling_parameters.desired_partition_count >= 1 && var.scaling_parameters.desired_partition_count <= 10)
    )
    error_message = "resource_aws_cloudsearch_domain, scaling_parameters.desired_partition_count must be between 1 and 10."
  }

  validation {
    condition = var.scaling_parameters == null || (
      var.scaling_parameters.desired_replication_count == null ||
      (var.scaling_parameters.desired_replication_count >= 1 && var.scaling_parameters.desired_replication_count <= 5)
    )
    error_message = "resource_aws_cloudsearch_domain, scaling_parameters.desired_replication_count must be between 1 and 5."
  }
}

variable "index_field" {
  description = "The index fields for documents added to the domain."
  type = list(object({
    name            = string
    type            = string
    analysis_scheme = optional(string)
    default_value   = optional(string)
    facet           = optional(bool)
    highlight       = optional(bool)
    return          = optional(bool)
    search          = optional(bool)
    sort            = optional(bool)
    source_fields   = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for field in var.index_field : can(regex("^[a-z][a-zA-Z0-9_]*$", field.name)) &&
      length(field.name) >= 1 && length(field.name) <= 64 && field.name != "score"
    ])
    error_message = "resource_aws_cloudsearch_domain, index_field.name must begin with a letter, be 1-64 characters long, contain only letters, numbers, and underscores, and cannot be 'score'."
  }

  validation {
    condition = alltrue([
      for field in var.index_field : contains([
        "date", "date-array", "double", "double-array",
        "int", "int-array", "literal", "literal-array",
        "text", "text-array"
      ], field.type)
    ])
    error_message = "resource_aws_cloudsearch_domain, index_field.type must be one of: date, date-array, double, double-array, int, int-array, literal, literal-array, text, text-array."
  }

  validation {
    condition = alltrue([
      for field in var.index_field : field.analysis_scheme == null || field.type == "text" || field.type == "text-array"
    ])
    error_message = "resource_aws_cloudsearch_domain, index_field.analysis_scheme can only be used with text or text-array field types."
  }

  validation {
    condition = alltrue([
      for field in var.index_field : field.highlight == null || field.type == "text" || field.type == "text-array"
    ])
    error_message = "resource_aws_cloudsearch_domain, index_field.highlight can only be used with text or text-array field types."
  }
}