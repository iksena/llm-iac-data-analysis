variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "access_grants_location_configuration" {
  description = "Access grants location configuration block"
  type = object({
    s3_sub_prefix = optional(string)
  })
  default = null
}

variable "access_grants_location_id" {
  description = "The ID of the S3 Access Grants location to with the access grant is giving access"
  type        = string
}

variable "account_id" {
  description = "The AWS account ID for the S3 Access Grants location. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null
}

variable "grantee" {
  description = "Grantee configuration block"
  type = object({
    grantee_identifier = string
    grantee_type       = string
  })
  default = null

  validation {
    condition     = var.grantee == null || contains(["DIRECTORY_USER", "DIRECTORY_GROUP", "IAM"], var.grantee.grantee_type)
    error_message = "resource_aws_s3control_access_grant, grantee_type must be one of: DIRECTORY_USER, DIRECTORY_GROUP, IAM."
  }
}

variable "permission" {
  description = "The access grant's level of access"
  type        = string

  validation {
    condition     = contains(["READ", "WRITE", "READWRITE"], var.permission)
    error_message = "resource_aws_s3control_access_grant, permission must be one of: READ, WRITE, READWRITE."
  }
}

variable "s3_prefix_type" {
  description = "If you are creating an access grant that grants access to only one object, set this to Object"
  type        = string
  default     = null

  validation {
    condition     = var.s3_prefix_type == null || var.s3_prefix_type == "Object"
    error_message = "resource_aws_s3control_access_grant, s3_prefix_type must be 'Object' when specified."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}