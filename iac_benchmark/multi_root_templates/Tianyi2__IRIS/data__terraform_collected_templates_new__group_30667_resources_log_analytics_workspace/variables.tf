
/*
  variables for log analytics workspace
*/ 

variable "log_analytics_workspace_name" {

  type        = string
  description = ""

}


/* 
  variables for resource group
*/ 

variable "resource_group_name" {

  type        = string
  description = ""

}

variable "resource_group_location" {

  type        = string
  description = ""

}



/*
  variables for tagging
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

variable "tag_environment" {

  type        = string
  description = "define the environment tag."

}

variable "tag_id" {

  type        = string
  description = "define the id tag."

}

variable "tag_owner" {

  type        = string
  description = "define the owner tag."

}

variable "tag_workload" {

  type        = string
  description = "define the owner workload."

}
