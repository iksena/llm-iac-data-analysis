variable "name" {
  description = "The name for the network profile"
  type        = string
}

variable "project_arn" {
  description = "The ARN of the project for the network profile"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the network profile"
  type        = string
  default     = null
}

variable "downlink_bandwidth_bits" {
  description = "The data throughput rate in bits per second, as an integer from 0 to 104857600"
  type        = number
  default     = 104857600

  validation {
    condition     = var.downlink_bandwidth_bits >= 0 && var.downlink_bandwidth_bits <= 104857600
    error_message = "resource_aws_devicefarm_network_profile, downlink_bandwidth_bits must be between 0 and 104857600."
  }
}

variable "downlink_delay_ms" {
  description = "Delay time for all packets to destination in milliseconds as an integer from 0 to 2000"
  type        = number
  default     = null

  validation {
    condition     = var.downlink_delay_ms == null || (var.downlink_delay_ms >= 0 && var.downlink_delay_ms <= 2000)
    error_message = "resource_aws_devicefarm_network_profile, downlink_delay_ms must be between 0 and 2000."
  }
}

variable "downlink_jitter_ms" {
  description = "Time variation in the delay of received packets in milliseconds as an integer from 0 to 2000"
  type        = number
  default     = null

  validation {
    condition     = var.downlink_jitter_ms == null || (var.downlink_jitter_ms >= 0 && var.downlink_jitter_ms <= 2000)
    error_message = "resource_aws_devicefarm_network_profile, downlink_jitter_ms must be between 0 and 2000."
  }
}

variable "downlink_loss_percent" {
  description = "Proportion of received packets that fail to arrive from 0 to 100 percent"
  type        = number
  default     = null

  validation {
    condition     = var.downlink_loss_percent == null || (var.downlink_loss_percent >= 0 && var.downlink_loss_percent <= 100)
    error_message = "resource_aws_devicefarm_network_profile, downlink_loss_percent must be between 0 and 100."
  }
}

variable "uplink_bandwidth_bits" {
  description = "The data throughput rate in bits per second, as an integer from 0 to 104857600"
  type        = number
  default     = 104857600

  validation {
    condition     = var.uplink_bandwidth_bits >= 0 && var.uplink_bandwidth_bits <= 104857600
    error_message = "resource_aws_devicefarm_network_profile, uplink_bandwidth_bits must be between 0 and 104857600."
  }
}

variable "uplink_delay_ms" {
  description = "Delay time for all packets to destination in milliseconds as an integer from 0 to 2000"
  type        = number
  default     = null

  validation {
    condition     = var.uplink_delay_ms == null || (var.uplink_delay_ms >= 0 && var.uplink_delay_ms <= 2000)
    error_message = "resource_aws_devicefarm_network_profile, uplink_delay_ms must be between 0 and 2000."
  }
}

variable "uplink_jitter_ms" {
  description = "Time variation in the delay of received packets in milliseconds as an integer from 0 to 2000"
  type        = number
  default     = null

  validation {
    condition     = var.uplink_jitter_ms == null || (var.uplink_jitter_ms >= 0 && var.uplink_jitter_ms <= 2000)
    error_message = "resource_aws_devicefarm_network_profile, uplink_jitter_ms must be between 0 and 2000."
  }
}

variable "uplink_loss_percent" {
  description = "Proportion of received packets that fail to arrive from 0 to 100 percent"
  type        = number
  default     = null

  validation {
    condition     = var.uplink_loss_percent == null || (var.uplink_loss_percent >= 0 && var.uplink_loss_percent <= 100)
    error_message = "resource_aws_devicefarm_network_profile, uplink_loss_percent must be between 0 and 100."
  }
}

variable "type" {
  description = "The type of network profile to create. Valid values are PRIVATE and CURATED"
  type        = string
  default     = null

  validation {
    condition     = var.type == null || contains(["PRIVATE", "CURATED"], var.type)
    error_message = "resource_aws_devicefarm_network_profile, type must be either PRIVATE or CURATED."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}