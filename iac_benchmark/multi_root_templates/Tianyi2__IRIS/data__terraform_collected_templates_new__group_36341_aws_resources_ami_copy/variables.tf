variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Region-unique name for the AMI."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ami_copy, name must not be empty."
  }
}

variable "source_ami_id" {
  description = "Id of the AMI to copy. This id must be valid in the region given by source_ami_region."
  type        = string

  validation {
    condition     = can(regex("^ami-[0-9a-f]{8,17}$", var.source_ami_id))
    error_message = "resource_aws_ami_copy, source_ami_id must be a valid AMI ID starting with 'ami-'."
  }
}

variable "source_ami_region" {
  description = "Region from which the AMI will be copied. This may be the same as the AWS provider region in order to create a copy within the same region."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.source_ami_region))
    error_message = "resource_aws_ami_copy, source_ami_region must be a valid AWS region format (e.g., us-west-1)."
  }
}

variable "destination_outpost_arn" {
  description = "ARN of the Outpost to which to copy the AMI. Only specify this parameter when copying an AMI from an AWS Region to an Outpost. The AMI must be in the Region of the destination Outpost."
  type        = string
  default     = null

  validation {
    condition     = var.destination_outpost_arn == null || can(regex("^arn:aws:outposts:[a-z0-9-]+:[0-9]+:outpost/op-[0-9a-f]+$", var.destination_outpost_arn))
    error_message = "resource_aws_ami_copy, destination_outpost_arn must be a valid Outpost ARN format."
  }
}

variable "encrypted" {
  description = "Whether the destination snapshots of the copied image should be encrypted. Defaults to false."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "Full ARN of the KMS Key to use when encrypting the snapshots of an image during a copy operation. If not specified, then the default AWS KMS Key will be used."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^(arn:aws:kms:[a-z0-9-]+:[0-9]+:key/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}|alias/.+)$", var.kms_key_id))
    error_message = "resource_aws_ami_copy, kms_key_id must be a valid KMS key ARN or alias."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for create operations."
  type        = string
  default     = "40m"
}

variable "update_timeout" {
  description = "Timeout for update operations."
  type        = string
  default     = "40m"
}

variable "delete_timeout" {
  description = "Timeout for delete operations."
  type        = string
  default     = "90m"
}