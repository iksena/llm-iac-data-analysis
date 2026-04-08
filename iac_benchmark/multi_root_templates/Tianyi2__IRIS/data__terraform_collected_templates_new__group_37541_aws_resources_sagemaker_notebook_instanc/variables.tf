variable "name" {
  description = "The name of the notebook instance (must be unique)."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_sagemaker_notebook_instance, name must not be empty."
  }
}

variable "role_arn" {
  description = "The ARN of the IAM role to be used by the notebook instance which allows SageMaker AI to call other services on your behalf."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_sagemaker_notebook_instance, role_arn must be a valid IAM role ARN."
  }
}

variable "instance_type" {
  description = "The name of ML compute instance type."
  type        = string

  validation {
    condition     = can(regex("^ml\\.", var.instance_type))
    error_message = "resource_aws_sagemaker_notebook_instance, instance_type must be a valid ML instance type starting with 'ml.'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "platform_identifier" {
  description = "The platform identifier of the notebook instance runtime environment. This value can be either notebook-al1-v1, notebook-al2-v1, notebook-al2-v2, or notebook-al2-v3."
  type        = string
  default     = null

  validation {
    condition = var.platform_identifier == null || contains([
      "notebook-al1-v1",
      "notebook-al2-v1",
      "notebook-al2-v2",
      "notebook-al2-v3"
    ], var.platform_identifier)
    error_message = "resource_aws_sagemaker_notebook_instance, platform_identifier must be one of: notebook-al1-v1, notebook-al2-v1, notebook-al2-v2, or notebook-al2-v3."
  }
}

variable "volume_size" {
  description = "The size, in GB, of the ML storage volume to attach to the notebook instance. The default value is 5 GB."
  type        = number
  default     = null

  validation {
    condition     = var.volume_size == null || var.volume_size > 0
    error_message = "resource_aws_sagemaker_notebook_instance, volume_size must be greater than 0."
  }
}

variable "subnet_id" {
  description = "The VPC subnet ID."
  type        = string
  default     = null

  validation {
    condition     = var.subnet_id == null || can(regex("^subnet-", var.subnet_id))
    error_message = "resource_aws_sagemaker_notebook_instance, subnet_id must be a valid subnet ID starting with 'subnet-'."
  }
}

variable "security_groups" {
  description = "The associated security groups."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_groups == null || alltrue([
      for sg in var.security_groups : can(regex("^sg-", sg))
    ])
    error_message = "resource_aws_sagemaker_notebook_instance, security_groups must contain valid security group IDs starting with 'sg-'."
  }
}

variable "additional_code_repositories" {
  description = "An array of up to three Git repositories to associate with the notebook instance. These can be either the names of Git repositories stored as resources in your account, or the URL of Git repositories in AWS CodeCommit or in any other Git repository."
  type        = list(string)
  default     = null

  validation {
    condition     = var.additional_code_repositories == null || length(var.additional_code_repositories) <= 3
    error_message = "resource_aws_sagemaker_notebook_instance, additional_code_repositories can contain at most 3 repositories."
  }
}

variable "default_code_repository" {
  description = "The Git repository associated with the notebook instance as its default code repository. This can be either the name of a Git repository stored as a resource in your account, or the URL of a Git repository in AWS CodeCommit or in any other Git repository."
  type        = string
  default     = null
}

variable "direct_internet_access" {
  description = "Set to Disabled to disable internet access to notebook. Requires security_groups and subnet_id to be set. Supported values: Enabled (Default) or Disabled."
  type        = string
  default     = null

  validation {
    condition     = var.direct_internet_access == null || contains(["Enabled", "Disabled"], var.direct_internet_access)
    error_message = "resource_aws_sagemaker_notebook_instance, direct_internet_access must be either 'Enabled' or 'Disabled'."
  }
}

variable "instance_metadata_service_configuration" {
  description = "Information on the IMDS configuration of the notebook instance."
  type = object({
    minimum_instance_metadata_service_version = optional(string)
  })
  default = null

  validation {
    condition = var.instance_metadata_service_configuration == null || (
      var.instance_metadata_service_configuration.minimum_instance_metadata_service_version == null ||
      contains(["1", "2"], var.instance_metadata_service_configuration.minimum_instance_metadata_service_version)
    )
    error_message = "resource_aws_sagemaker_notebook_instance, minimum_instance_metadata_service_version must be either '1' or '2'."
  }
}

variable "kms_key_id" {
  description = "The AWS Key Management Service (AWS KMS) key that Amazon SageMaker AI uses to encrypt the model artifacts at rest using Amazon S3 server-side encryption."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^(arn:aws:kms:|[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})", var.kms_key_id))
    error_message = "resource_aws_sagemaker_notebook_instance, kms_key_id must be a valid KMS key ID or ARN."
  }
}

variable "lifecycle_config_name" {
  description = "The name of a lifecycle configuration to associate with the notebook instance."
  type        = string
  default     = null
}

variable "root_access" {
  description = "Whether root access is Enabled or Disabled for users of the notebook instance. The default value is Enabled."
  type        = string
  default     = null

  validation {
    condition     = var.root_access == null || contains(["Enabled", "Disabled"], var.root_access)
    error_message = "resource_aws_sagemaker_notebook_instance, root_access must be either 'Enabled' or 'Disabled'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = null
}