variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Region-unique name for the AMI"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-._]{0,126}[a-zA-Z0-9]$", var.name))
    error_message = "resource_aws_ami, name must be 1-128 characters long and can contain letters, numbers, hyphens, periods, and underscores."
  }
}

variable "boot_mode" {
  description = "Boot mode of the AMI"
  type        = string
  default     = null
  validation {
    condition     = var.boot_mode == null ? true : contains(["legacy-bios", "uefi", "uefi-preferred"], var.boot_mode)
    error_message = "resource_aws_ami, boot_mode must be one of: legacy-bios, uefi, uefi-preferred."
  }
}

variable "deprecation_time" {
  description = "Date and time to deprecate the AMI in RFC3339 format"
  type        = string
  default     = null
  validation {
    condition     = var.deprecation_time == null ? true : can(formatdate("RFC3339", var.deprecation_time))
    error_message = "resource_aws_ami, deprecation_time must be a valid RFC3339 timestamp format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "description" {
  description = "Longer, human-readable description for the AMI"
  type        = string
  default     = null
}

variable "ena_support" {
  description = "Whether enhanced networking with ENA is enabled"
  type        = bool
  default     = false
}

variable "root_device_name" {
  description = "Name of the root device"
  type        = string
  default     = null
}

variable "virtualization_type" {
  description = "Virtualization mode for created instances"
  type        = string
  default     = "paravirtual"
  validation {
    condition     = contains(["paravirtual", "hvm"], var.virtualization_type)
    error_message = "resource_aws_ami, virtualization_type must be either 'paravirtual' or 'hvm'."
  }
}

variable "architecture" {
  description = "Machine architecture for created instances"
  type        = string
  default     = "x86_64"
  validation {
    condition     = contains(["i386", "x86_64", "arm64"], var.architecture)
    error_message = "resource_aws_ami, architecture must be one of: i386, x86_64, arm64."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tpm_support" {
  description = "TPM support configuration"
  type        = string
  default     = null
  validation {
    condition     = var.tpm_support == null ? true : var.tpm_support == "v2.0"
    error_message = "resource_aws_ami, tpm_support must be 'v2.0' when specified."
  }
}

variable "imds_support" {
  description = "Instance Metadata Service version support"
  type        = string
  default     = null
  validation {
    condition     = var.imds_support == null ? true : contains(["v1.0", "v2.0"], var.imds_support)
    error_message = "resource_aws_ami, imds_support must be either 'v1.0' or 'v2.0'."
  }
}

variable "uefi_data" {
  description = "Base64 representation of the non-volatile UEFI variable store"
  type        = string
  default     = null
}

# Paravirtual specific variables
variable "image_location" {
  description = "Path to an S3 object containing an image manifest (required for paravirtual)"
  type        = string
  default     = null
  validation {
    condition     = var.virtualization_type == "paravirtual" ? var.image_location != null : true
    error_message = "resource_aws_ami, image_location is required when virtualization_type is 'paravirtual'."
  }
}

variable "kernel_id" {
  description = "ID of the kernel image (AKI) for paravirtual kernel (required for paravirtual)"
  type        = string
  default     = null
  validation {
    condition     = var.virtualization_type == "paravirtual" ? var.kernel_id != null : true
    error_message = "resource_aws_ami, kernel_id is required when virtualization_type is 'paravirtual'."
  }
}

variable "ramdisk_id" {
  description = "ID of an initrd image (ARI) for booting instances (optional for paravirtual)"
  type        = string
  default     = null
}

# HVM specific variables
variable "sriov_net_support" {
  description = "Enhanced networking support (for HVM virtualization)"
  type        = string
  default     = "simple"
  validation {
    condition     = var.sriov_net_support == null ? true : var.sriov_net_support == "simple"
    error_message = "resource_aws_ami, sriov_net_support must be 'simple' when specified."
  }
}

variable "ebs_block_devices" {
  description = "List of EBS block devices to attach to created instances"
  type = list(object({
    device_name           = string
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    snapshot_id           = optional(string)
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
    outpost_arn           = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for device in var.ebs_block_devices :
      device.volume_type == null ? true : contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], device.volume_type)
    ])
    error_message = "resource_aws_ami, ebs_block_device volume_type must be one of: standard, gp2, gp3, io1, io2, sc1, st1."
  }

  validation {
    condition = alltrue([
      for device in var.ebs_block_devices :
      (device.volume_type == "io1" || device.volume_type == "io2") ? device.iops != null : true
    ])
    error_message = "resource_aws_ami, ebs_block_device iops is required when volume_type is 'io1' or 'io2'."
  }

  validation {
    condition = alltrue([
      for device in var.ebs_block_devices :
      !(device.encrypted == true && device.snapshot_id != null)
    ])
    error_message = "resource_aws_ami, ebs_block_device cannot specify both encrypted and snapshot_id."
  }

  validation {
    condition = alltrue([
      for device in var.ebs_block_devices :
      device.snapshot_id != null ? true : device.volume_size != null
    ])
    error_message = "resource_aws_ami, ebs_block_device volume_size is required unless snapshot_id is set."
  }

  validation {
    condition = alltrue([
      for device in var.ebs_block_devices :
      device.volume_type == "gp3" || device.throughput == null
    ])
    error_message = "resource_aws_ami, ebs_block_device throughput is only valid for volume_type 'gp3'."
  }
}

variable "ephemeral_block_devices" {
  description = "List of ephemeral block devices to attach to created instances"
  type = list(object({
    device_name  = string
    virtual_name = string
  }))
  default = []

  validation {
    condition = alltrue([
      for device in var.ephemeral_block_devices :
      can(regex("^ephemeral[0-9]+$", device.virtual_name))
    ])
    error_message = "resource_aws_ami, ephemeral_block_device virtual_name must be of the form 'ephemeralN' where N is a volume number starting from zero."
  }
}