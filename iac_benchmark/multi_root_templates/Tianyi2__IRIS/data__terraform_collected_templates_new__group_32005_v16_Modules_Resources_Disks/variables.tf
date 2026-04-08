# Required resource variables
variable "resource_name" {
  description = "Desired name for the provisioned resources"
  type        = string
}

variable "resource_group_name" {
  description = "Desired resource group name for the provisioned resources"
  type        = string
}

variable "resource_environment" {
  description = "Desired environment for the provisioned resources"
  type        = string
}

variable "resource_location" {
  description = "Desired location for the provisioned resources"
  type        = string
}

variable "resource_zone" {
  description = "Desired zone for the provisioned resources"
  type        = any
}

variable "resource_virtual_machine_id" {
  description = "Resource virtual machine id"
  type        = string
}

variable "vm_data_disk_size" {
  description = "Desired size for the provisioned resources"
  type        = number
}

variable "vm_data_disk_count" {
  description = "Desired size for the provisioned resources for each service"
  type        = number
}