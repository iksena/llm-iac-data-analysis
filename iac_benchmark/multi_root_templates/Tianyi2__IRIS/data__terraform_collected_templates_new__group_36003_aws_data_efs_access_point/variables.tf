variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "access_point_id" {
  description = "ID that identifies the file system."
  type        = string

  validation {
    condition     = can(regex("^fsap-[0-9a-f]{8,40}$", var.access_point_id))
    error_message = "data_aws_efs_access_point, access_point_id must be a valid EFS access point ID starting with 'fsap-' followed by 8-40 hexadecimal characters."
  }
}