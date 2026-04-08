variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "tier" {
  type = string
}

variable "disk_size_gb" {
  type = number
}

variable "enable_public_ip" {
  type = bool
}

variable "private_network_id" {
  type = string
}
