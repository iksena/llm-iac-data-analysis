variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "device_name" {
  description = "The device name to expose to the instance (for example, /dev/sdh or xvdh)."
  type        = string

  validation {
    condition     = can(regex("^(/dev/sd[a-z]|/dev/xvd[a-z]|xvd[a-z])$", var.device_name))
    error_message = "resource_aws_volume_attachment, device_name must be a valid device name (e.g., /dev/sdh, /dev/xvdh, or xvdh)."
  }
}

variable "instance_id" {
  description = "ID of the Instance to attach to."
  type        = string

  validation {
    condition     = can(regex("^i-[0-9a-f]{8,17}$", var.instance_id))
    error_message = "resource_aws_volume_attachment, instance_id must be a valid EC2 instance ID (e.g., i-1234567890abcdef0)."
  }
}

variable "volume_id" {
  description = "ID of the Volume to be attached."
  type        = string

  validation {
    condition     = can(regex("^vol-[0-9a-f]{8,17}$", var.volume_id))
    error_message = "resource_aws_volume_attachment, volume_id must be a valid EBS volume ID (e.g., vol-1234567890abcdef0)."
  }
}

variable "force_detach" {
  description = "Set to true if you want to force the volume to detach. Useful if previous attempts failed, but use this option only as a last resort, as this can result in data loss."
  type        = bool
  default     = null
}

variable "skip_destroy" {
  description = "Set this to true if you do not wish to detach the volume from the instance to which it is attached at destroy time, and instead just remove the attachment from Terraform state."
  type        = bool
  default     = null
}

variable "stop_instance_before_detaching" {
  description = "Set this to true to ensure that the target instance is stopped before trying to detach the volume. Stops the instance, if it is not already stopped."
  type        = bool
  default     = null
}