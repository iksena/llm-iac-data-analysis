variable "gateway_name" {
  description = "Name of the gateway"
  type        = string
  validation {
    condition     = length(var.gateway_name) > 0
    error_message = "resource_aws_storagegateway_gateway, gateway_name cannot be empty."
  }
}

variable "gateway_timezone" {
  description = "Time zone for the gateway. The time zone is of the format 'GMT', 'GMT-hr:mm', or 'GMT+hr:mm'"
  type        = string
  validation {
    condition     = can(regex("^GMT([+-]\\d{1,2}:\\d{2})?$", var.gateway_timezone))
    error_message = "resource_aws_storagegateway_gateway, gateway_timezone must be in format GMT, GMT-hr:mm, or GMT+hr:mm."
  }
}

variable "activation_key" {
  description = "Gateway activation key during resource creation. Conflicts with gateway_ip_address"
  type        = string
  default     = null
}

variable "average_download_rate_limit_in_bits_per_sec" {
  description = "The average download bandwidth rate limit in bits per second. Supported for CACHED, STORED, and VTL gateway types"
  type        = number
  default     = null
  validation {
    condition     = var.average_download_rate_limit_in_bits_per_sec == null || var.average_download_rate_limit_in_bits_per_sec >= 0
    error_message = "resource_aws_storagegateway_gateway, average_download_rate_limit_in_bits_per_sec must be a non-negative number."
  }
}

variable "average_upload_rate_limit_in_bits_per_sec" {
  description = "The average upload bandwidth rate limit in bits per second. Supported for CACHED, STORED, and VTL gateway types"
  type        = number
  default     = null
  validation {
    condition     = var.average_upload_rate_limit_in_bits_per_sec == null || var.average_upload_rate_limit_in_bits_per_sec >= 0
    error_message = "resource_aws_storagegateway_gateway, average_upload_rate_limit_in_bits_per_sec must be a non-negative number."
  }
}

variable "gateway_ip_address" {
  description = "Gateway IP address to retrieve activation key during resource creation. Conflicts with activation_key"
  type        = string
  default     = null
  validation {
    condition     = var.gateway_ip_address == null || can(cidrhost("${var.gateway_ip_address}/32", 0))
    error_message = "resource_aws_storagegateway_gateway, gateway_ip_address must be a valid IP address."
  }
}

variable "gateway_type" {
  description = "Type of the gateway. Valid values: CACHED, FILE_FSX_SMB, FILE_S3, STORED, VTL"
  type        = string
  default     = "STORED"
  validation {
    condition     = contains(["CACHED", "FILE_FSX_SMB", "FILE_S3", "STORED", "VTL"], var.gateway_type)
    error_message = "resource_aws_storagegateway_gateway, gateway_type must be one of: CACHED, FILE_FSX_SMB, FILE_S3, STORED, VTL."
  }
}

variable "gateway_vpc_endpoint" {
  description = "VPC endpoint address to be used when activating your gateway"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon CloudWatch log group to use to monitor and log events in the gateway"
  type        = string
  default     = null
  validation {
    condition     = var.cloudwatch_log_group_arn == null || can(regex("^arn:aws[a-z0-9-]*:logs:[a-z0-9-]+:[0-9]{12}:log-group:", var.cloudwatch_log_group_arn))
    error_message = "resource_aws_storagegateway_gateway, cloudwatch_log_group_arn must be a valid CloudWatch log group ARN."
  }
}

variable "maintenance_start_time" {
  description = "The gateway's weekly maintenance start time information"
  type = object({
    day_of_month   = optional(number)
    day_of_week    = optional(number)
    hour_of_day    = number
    minute_of_hour = number
  })
  default = null
  validation {
    condition = var.maintenance_start_time == null || (
      var.maintenance_start_time.hour_of_day >= 0 && var.maintenance_start_time.hour_of_day <= 23 &&
      var.maintenance_start_time.minute_of_hour >= 0 && var.maintenance_start_time.minute_of_hour <= 59
    )
    error_message = "resource_aws_storagegateway_gateway, maintenance_start_time hour_of_day must be 0-23 and minute_of_hour must be 0-59."
  }
  validation {
    condition = var.maintenance_start_time == null || var.maintenance_start_time.day_of_month == null || (
      var.maintenance_start_time.day_of_month >= 1 && var.maintenance_start_time.day_of_month <= 28
    )
    error_message = "resource_aws_storagegateway_gateway, maintenance_start_time day_of_month must be between 1 and 28."
  }
  validation {
    condition = var.maintenance_start_time == null || var.maintenance_start_time.day_of_week == null || (
      var.maintenance_start_time.day_of_week >= 0 && var.maintenance_start_time.day_of_week <= 6
    )
    error_message = "resource_aws_storagegateway_gateway, maintenance_start_time day_of_week must be between 0 (Sunday) and 6 (Saturday)."
  }
}

variable "medium_changer_type" {
  description = "Type of medium changer to use for tape gateway. Valid values: STK-L700, AWS-Gateway-VTL, IBM-03584L32-0402"
  type        = string
  default     = null
  validation {
    condition     = var.medium_changer_type == null || contains(["STK-L700", "AWS-Gateway-VTL", "IBM-03584L32-0402"], var.medium_changer_type)
    error_message = "resource_aws_storagegateway_gateway, medium_changer_type must be one of: STK-L700, AWS-Gateway-VTL, IBM-03584L32-0402."
  }
}

variable "smb_active_directory_settings" {
  description = "Nested argument with Active Directory domain join information for SMB file shares"
  type = object({
    domain_name         = string
    password            = string
    username            = string
    timeout_in_seconds  = optional(number, 20)
    organizational_unit = optional(string)
    domain_controllers  = optional(list(string))
  })
  default = null
  validation {
    condition = var.smb_active_directory_settings == null || (
      length(var.smb_active_directory_settings.domain_name) > 0 &&
      length(var.smb_active_directory_settings.password) > 0 &&
      length(var.smb_active_directory_settings.username) > 0
    )
    error_message = "resource_aws_storagegateway_gateway, smb_active_directory_settings domain_name, password, and username are required and cannot be empty."
  }
  validation {
    condition = var.smb_active_directory_settings == null || (
      var.smb_active_directory_settings.timeout_in_seconds >= 1 && var.smb_active_directory_settings.timeout_in_seconds <= 3600
    )
    error_message = "resource_aws_storagegateway_gateway, smb_active_directory_settings timeout_in_seconds must be between 1 and 3600."
  }
}

variable "smb_guest_password" {
  description = "Guest password for Server Message Block (SMB) file shares. Only valid for FILE_S3 and FILE_FSX_SMB gateway types"
  type        = string
  default     = null
  sensitive   = true
}

variable "smb_security_strategy" {
  description = "Specifies the type of security strategy. Valid values: ClientSpecified, MandatorySigning, MandatoryEncryption"
  type        = string
  default     = null
  validation {
    condition     = var.smb_security_strategy == null || contains(["ClientSpecified", "MandatorySigning", "MandatoryEncryption"], var.smb_security_strategy)
    error_message = "resource_aws_storagegateway_gateway, smb_security_strategy must be one of: ClientSpecified, MandatorySigning, MandatoryEncryption."
  }
}

variable "smb_file_share_visibility" {
  description = "Specifies whether the shares on this gateway appear when listing shares"
  type        = bool
  default     = null
}

variable "tape_drive_type" {
  description = "Type of tape drive to use for tape gateway. Valid values: IBM-ULT3580-TD5"
  type        = string
  default     = null
  validation {
    condition     = var.tape_drive_type == null || var.tape_drive_type == "IBM-ULT3580-TD5"
    error_message = "resource_aws_storagegateway_gateway, tape_drive_type must be IBM-ULT3580-TD5."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}