# Spot Instance Request specific variables
variable "spot_price" {
  description = "The maximum price to request on the spot market"
  type        = string
  default     = null
}

variable "wait_for_fulfillment" {
  description = "If set, Terraform will wait for the Spot Request to be fulfilled, and will throw an error if the timeout of 10m is reached"
  type        = bool
  default     = false
}

variable "spot_type" {
  description = "If set to one-time, after the instance is terminated, the spot request will be closed"
  type        = string
  default     = "persistent"
  validation {
    condition     = contains(["one-time", "persistent"], var.spot_type)
    error_message = "resource_aws_spot_instance_request, spot_type must be either 'one-time' or 'persistent'."
  }
}

variable "launch_group" {
  description = "A launch group is a group of spot instances that launch together and terminate together"
  type        = string
  default     = null
}

variable "instance_interruption_behavior" {
  description = "Indicates Spot instance behavior when it is interrupted. Valid values are terminate, stop, or hibernate"
  type        = string
  default     = "terminate"
  validation {
    condition     = contains(["terminate", "stop", "hibernate"], var.instance_interruption_behavior)
    error_message = "resource_aws_spot_instance_request, instance_interruption_behavior must be one of 'terminate', 'stop', or 'hibernate'."
  }
}

variable "valid_until" {
  description = "The end date and time of the request, in UTC RFC3339 format (for example, YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = null
  validation {
    condition     = var.valid_until == null ? true : can(formatdate("2006-01-02T15:04:05Z07:00", var.valid_until))
    error_message = "resource_aws_spot_instance_request, valid_until must be in RFC3339 format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "valid_from" {
  description = "The start date and time of the request, in UTC RFC3339 format (for example, YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = null
  validation {
    condition     = var.valid_from == null ? true : can(formatdate("2006-01-02T15:04:05Z07:00", var.valid_from))
    error_message = "resource_aws_spot_instance_request, valid_from must be in RFC3339 format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

# Required EC2 Instance variables
variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  validation {
    condition     = can(regex("^ami-[0-9a-f]{8}([0-9a-f]{9})?$", var.ami))
    error_message = "resource_aws_spot_instance_request, ami must be a valid AMI ID (ami-xxxxxxxx or ami-xxxxxxxxxxxxxxxxx)."
  }
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  validation {
    condition     = length(var.instance_type) > 0
    error_message = "resource_aws_spot_instance_request, instance_type cannot be empty."
  }
}

# Optional EC2 Instance variables
variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
  validation {
    condition     = var.subnet_id == null ? true : can(regex("^subnet-[0-9a-f]{8}([0-9a-f]{9})?$", var.subnet_id))
    error_message = "resource_aws_spot_instance_request, subnet_id must be a valid subnet ID (subnet-xxxxxxxx or subnet-xxxxxxxxxxxxxxxxx)."
  }
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
  validation {
    condition = length(var.vpc_security_group_ids) == 0 ? true : alltrue([
      for sg_id in var.vpc_security_group_ids : can(regex("^sg-[0-9a-f]{8}([0-9a-f]{9})?$", sg_id))
    ])
    error_message = "resource_aws_spot_instance_request, vpc_security_group_ids must contain valid security group IDs (sg-xxxxxxxx or sg-xxxxxxxxxxxxxxxxx)."
  }
}

variable "security_groups" {
  description = "A list of security group names to associate with. If you are creating Instances in a VPC, use vpc_security_group_ids instead"
  type        = list(string)
  default     = []
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with"
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC)"
  type        = string
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated", "host"], var.tenancy)
    error_message = "resource_aws_spot_instance_request, tenancy must be one of 'default', 'dedicated', or 'host'."
  }
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances"
  type        = string
  default     = null
  validation {
    condition     = var.instance_initiated_shutdown_behavior == null ? true : contains(["stop", "terminate"], var.instance_initiated_shutdown_behavior)
    error_message = "resource_aws_spot_instance_request, instance_initiated_shutdown_behavior must be either 'stop' or 'terminate'."
  }
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
  validation {
    condition     = var.private_ip == null ? true : can(cidrhost("10.0.0.0/8", 0)) && can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.private_ip))
    error_message = "resource_aws_spot_instance_request, private_ip must be a valid IPv4 address."
  }
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface"
  type        = number
  default     = null
  validation {
    condition     = var.ipv6_address_count == null ? true : var.ipv6_address_count >= 0
    error_message = "resource_aws_spot_instance_request, ipv6_address_count must be a non-negative number."
  }
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = []
}

variable "availability_zone" {
  description = "The availability zone to launch the instance in"
  type        = string
  default     = null
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it"
  type        = bool
  default     = false
}

# Block device variables
variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type = object({
    volume_type           = optional(string, "gp3")
    volume_size           = optional(number)
    iops                  = optional(number)
    throughput            = optional(number)
    delete_on_termination = optional(bool, true)
    encrypted             = optional(bool, false)
    kms_key_id            = optional(string)
    tags                  = optional(map(string), {})
  })
  default = null
  validation {
    condition     = var.root_block_device == null ? true : contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], var.root_block_device.volume_type)
    error_message = "resource_aws_spot_instance_request, root_block_device volume_type must be one of 'standard', 'gp2', 'gp3', 'io1', 'io2', 'sc1', or 'st1'."
  }
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type = list(object({
    device_name           = string
    volume_type           = optional(string, "gp3")
    volume_size           = optional(number)
    iops                  = optional(number)
    throughput            = optional(number)
    delete_on_termination = optional(bool, true)
    encrypted             = optional(bool, false)
    kms_key_id            = optional(string)
    snapshot_id           = optional(string)
    tags                  = optional(map(string), {})
  }))
  default = []
  validation {
    condition = alltrue([
      for device in var.ebs_block_device : contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], device.volume_type)
    ])
    error_message = "resource_aws_spot_instance_request, ebs_block_device volume_type must be one of 'standard', 'gp2', 'gp3', 'io1', 'io2', 'sc1', or 'st1'."
  }
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type = list(object({
    device_name  = string
    virtual_name = optional(string)
    no_device    = optional(bool, false)
  }))
  default = []
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type = list(object({
    network_interface_id  = string
    device_index          = number
    delete_on_termination = optional(bool, false)
  }))
  default = []
  validation {
    condition = alltrue([
      for ni in var.network_interface : can(regex("^eni-[0-9a-f]{8}([0-9a-f]{9})?$", ni.network_interface_id))
    ])
    error_message = "resource_aws_spot_instance_request, network_interface network_interface_id must be a valid network interface ID (eni-xxxxxxxx or eni-xxxxxxxxxxxxxxxxx)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the Spot Instance Request"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "10m")
    read   = optional(string, "15m")
    delete = optional(string, "20m")
  })
  default = {}
}