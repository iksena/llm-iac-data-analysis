
/*
    - variables for resource group
*/ 

variable "resource_group_name" {

  type        = string
  description = "define the resource group name."

}

variable "resource_group_location" {

  type        = string
  description = "define the resource group location."

}



/*
    - variables for tagging
        - tag_backup
        - tag_environment
        - tag_id
        - tag_owner
        - tag_workload
*/ 

variable "tag_backup" {

  type        = string
  description = "define the backup tag."

}

variable "tag_owner" {

  type        = string
  description = "define the entity."

}

variable "tag_environment" {

  type        = string
  description = "define the environment."

}

variable "tag_id" {

  type        = string
  description = "define the location where the resource has been deployed."

}

variable "tag_workload" {

  type        = string
  description = "define the owner of the application."

}



/*
    - variables for network
*/ 

variable "gateway_ip_address" {

  type        = string
  description = "."

}

variable "subnets" {

  default     = {}

}

variable "virtual_network_name" {

  type        = string
  default     = ""
  description = ""

}

variable "virtual_network_address_prefix" {

  type        = string
  description = "define the ip address range for the virtual network."

}

variable "dns_primary_server_ip_address" {

  type        = string
  description = "define the ip address for the dns primary server."

}
