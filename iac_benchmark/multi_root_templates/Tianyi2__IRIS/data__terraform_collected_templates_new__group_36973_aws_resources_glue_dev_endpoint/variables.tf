variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "arguments" {
  description = "A map of arguments used to configure the endpoint"
  type        = map(string)
  default     = {}
}

variable "extra_jars_s3_path" {
  description = "Path to one or more Java Jars in an S3 bucket that should be loaded in this endpoint"
  type        = string
  default     = null
}

variable "extra_python_libs_s3_path" {
  description = "Path(s) to one or more Python libraries in an S3 bucket that should be loaded in this endpoint. Multiple values must be complete paths separated by a comma"
  type        = string
  default     = null
}

variable "glue_version" {
  description = "Specifies the versions of Python and Apache Spark to use"
  type        = string
  default     = "0.9"
}

variable "name" {
  description = "The name of this endpoint. It must be unique in your account"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_glue_dev_endpoint, name must not be empty."
  }
}

variable "number_of_nodes" {
  description = "The number of AWS Glue Data Processing Units (DPUs) to allocate to this endpoint. Conflicts with worker_type"
  type        = number
  default     = null

  validation {
    condition     = var.number_of_nodes == null || var.number_of_nodes > 0
    error_message = "resource_aws_glue_dev_endpoint, number_of_nodes must be greater than 0 when specified."
  }
}

variable "number_of_workers" {
  description = "The number of workers of a defined worker type that are allocated to this endpoint. This field is available only when you choose worker type G.1X or G.2X"
  type        = number
  default     = null

  validation {
    condition     = var.number_of_workers == null || var.number_of_workers > 0
    error_message = "resource_aws_glue_dev_endpoint, number_of_workers must be greater than 0 when specified."
  }
}

variable "public_key" {
  description = "The public key to be used by this endpoint for authentication"
  type        = string
  default     = null
}

variable "public_keys" {
  description = "A list of public keys to be used by this endpoint for authentication"
  type        = list(string)
  default     = []
}

variable "role_arn" {
  description = "The IAM role for this endpoint"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_glue_dev_endpoint, role_arn must be a valid IAM role ARN."
  }
}

variable "security_configuration" {
  description = "The name of the Security Configuration structure to be used with this endpoint"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security group IDs for the security groups to be used by this endpoint"
  type        = list(string)
  default     = []
}

variable "subnet_id" {
  description = "The subnet ID for the new endpoint to use"
  type        = string
  default     = null

  validation {
    condition     = var.subnet_id == null || can(regex("^subnet-[a-z0-9]+$", var.subnet_id))
    error_message = "resource_aws_glue_dev_endpoint, subnet_id must be a valid subnet ID format (subnet-xxxxxxxx) when specified."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "worker_type" {
  description = "The type of predefined worker that is allocated to this endpoint. Accepts a value of Standard, G.1X, or G.2X"
  type        = string
  default     = null

  validation {
    condition     = var.worker_type == null || contains(["Standard", "G.1X", "G.2X"], var.worker_type)
    error_message = "resource_aws_glue_dev_endpoint, worker_type must be one of: Standard, G.1X, or G.2X."
  }
}