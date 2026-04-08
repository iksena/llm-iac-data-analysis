variable "name" {
  description = "Name of the input."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_medialive_input, name must not be empty."
  }
}

variable "input_security_groups" {
  description = "List of input security groups."
  type        = list(string)

  validation {
    condition     = length(var.input_security_groups) > 0
    error_message = "resource_aws_medialive_input, input_security_groups must contain at least one security group."
  }
}

variable "type" {
  description = "The different types of inputs that AWS Elemental MediaLive supports."
  type        = string

  validation {
    condition = contains([
      "UDP_PUSH", "RTP_PUSH", "RTMP_PUSH", "RTMP_PULL", "URL_PULL",
      "MP4_FILE", "MEDIACONNECT", "INPUT_DEVICE", "AWS_CDI", "TS_FILE"
    ], var.type)
    error_message = "resource_aws_medialive_input, type must be a valid MediaLive input type."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "destinations" {
  description = "Destination settings for PUSH type inputs."
  type = list(object({
    stream_name = string
  }))
  default = null
}

variable "input_devices" {
  description = "Settings for the devices."
  type = list(object({
    id = string
  }))
  default = null

  validation {
    condition = var.input_devices == null ? true : alltrue([
      for device in var.input_devices : length(device.id) > 0
    ])
    error_message = "resource_aws_medialive_input, input_devices id must not be empty for any device."
  }
}

variable "media_connect_flows" {
  description = "A list of the MediaConnect Flows."
  type = list(object({
    flow_arn = string
  }))
  default = null

  validation {
    condition = var.media_connect_flows == null ? true : alltrue([
      for flow in var.media_connect_flows : can(regex("^arn:aws:mediaconnect:", flow.flow_arn))
    ])
    error_message = "resource_aws_medialive_input, media_connect_flows flow_arn must be a valid MediaConnect flow ARN."
  }
}

variable "role_arn" {
  description = "The ARN of the role this input assumes during and after creation."
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null ? true : can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_medialive_input, role_arn must be a valid IAM role ARN."
  }
}

variable "sources" {
  description = "The source URLs for a PULL-type input."
  type = list(object({
    password_param = optional(string)
    url            = string
    username       = optional(string)
  }))
  default = null

  validation {
    condition = var.sources == null ? true : alltrue([
      for source in var.sources : length(source.url) > 0
    ])
    error_message = "resource_aws_medialive_input, sources url must not be empty for any source."
  }

  validation {
    condition = var.sources == null ? true : alltrue([
      for source in var.sources : can(regex("^https?://", source.url))
    ])
    error_message = "resource_aws_medialive_input, sources url must be a valid HTTP or HTTPS URL."
  }
}

variable "tags" {
  description = "A map of tags to assign to the Input."
  type        = map(string)
  default     = {}
}

variable "vpc" {
  description = "Settings for a private VPC Input."
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null

  validation {
    condition     = var.vpc == null ? true : length(var.vpc.subnet_ids) == 2
    error_message = "resource_aws_medialive_input, vpc subnet_ids must contain exactly 2 VPC subnet IDs from the same VPC."
  }

  validation {
    condition     = var.vpc == null ? true : length(var.vpc.security_group_ids) <= 5 && length(var.vpc.security_group_ids) > 0
    error_message = "resource_aws_medialive_input, vpc security_group_ids must contain between 1 and 5 EC2 VPC security group IDs."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_medialive_input, timeouts must be valid duration strings (e.g., '30m', '1h')."
  }
}