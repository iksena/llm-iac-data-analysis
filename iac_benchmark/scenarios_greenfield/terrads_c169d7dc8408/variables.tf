variable "create" {
  type        = bool
  default     = true
  description = "Whether to create resources."
}

variable "name" {
  type        = string
  description = "Name of the instances."
  default     = "benchmark-instance"
}

variable "number_of_instances" {
  type        = number
  default     = 1
  description = "Number of instances."
}

variable "availability_zone" {
  type        = string
  default     = ""
  description = "The Availability Zone in which to create instances."
}

variable "blueprint_id" {
  type        = string
  default     = "ubuntu_20_04"
  description = "The ID for a virtual private server image."
}

variable "bundle_id" {
  type        = string
  default     = "nano_2_1"
  description = "The bundle of specification information."
}


variable "use_default_key_pair" {
  type        = bool
  default     = false
  description = "Whether to use default key."
}

variable "user_data" {
  type        = string
  default     = ""
  description = "User data of the instances."
}

variable "create_static_ip" {
  type        = bool
  default     = true
  description = "Create and attach a statis IP to the instance"
}

variable "ip_address_type" {
  type        = string
  default     = "dualstack"
  description = "The IP address type of the Lightsail Instance. Valid Values: dualstack | ipv4."
}

variable "port_info" {
  type = any
  default = [
    { port = 443 },
    { port = 80 }
  ]
  description = "Configuration block with port information."
}

variable "key_pair_name" {
  type        = string
  default     = ""
  description = "The key name to use for the instance."
}

variable "public_key" {
  type        = string
  default     = ""
  description = "The public key."
}

variable "add_ons" {
  type        = map(string)
  default     = {}
  description = "The add on configuration for the instance."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags."
}
