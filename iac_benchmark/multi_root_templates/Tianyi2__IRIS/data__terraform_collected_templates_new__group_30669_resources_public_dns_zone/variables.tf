
// variables for dns

variable "dns_zone_name" {

  type        = string
  description = "define the dns zone name."

}


// variables for resource group

variable "resource_group_name" {

  type        = string
  description = "define the resource group name."

}


// variables for tagging

variable "tag_environment" {

  type        = string
  description = "define the environment of the deployment."

}

variable "tag_id" {

  type        = string
  description = "define the name of entity/company."

}

variable "tag_owner" {

  type        = string
  description = "define the name of entity/company."

}

variable "tag_workload" {

  type        = string
  description = "define the MSP in charge of maintenance of the resources."

}
