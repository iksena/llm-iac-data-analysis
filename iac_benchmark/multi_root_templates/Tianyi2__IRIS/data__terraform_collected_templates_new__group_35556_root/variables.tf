
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "managedby" {
  type        = string
  default     = "info@cypik.com"
  description = "ManagedBy, eg 'info@cypik.com'"
}

variable "repository" {
  type        = string
  default     = "https://github.com/cypik/terraform-azure-network-security-group"
  description = "Terraform current module repo"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the network security group."
}

variable "resource_group_location" {
  type        = string
  description = "The Location of the resource group where to create the network security group."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "inbound_rules" {
  type        = any
  default     = []
  description = "List of objects that represent the configuration of each inbound rule."
}

variable "outbound_rules" {
  type        = any
  default     = []
  description = "List of objects that represent the configuration of each outbound rule."
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "The ID of the Subnet. Changing this forces a new resource to be created."
}

variable "create" {
  type        = string
  default     = "30m"
  description = "Used when creating the Resource Group."
}

variable "update" {
  type        = string
  default     = "30m"
  description = "Used when updating the Resource Group."
}

variable "read" {
  type        = string
  default     = "5m"
  description = "Used when retrieving the Resource Group."
}

variable "delete" {
  type        = string
  default     = "30m"
  description = "Used when deleting the Resource Group."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "log analytics workspace id to pass it to destination details of diagnosys setting of NSG."
}

variable "enable_flow_logs" {
  type        = bool
  default     = false
  description = "Flag to be set true when network security group flow logging feature is to be enabled."
}

variable "network_watcher_name" {
  type        = string
  default     = null
  description = "The name of the Network Watcher. Changing this forces a new resource to be created."
}

variable "flow_log_storage_account_id" {
  type        = string
  default     = null
  description = "The id of storage account in which flow logs will be received. Note: Currently, only standard-tier storage accounts are supported."
}

variable "flow_log_retention_policy_enabled" {
  type        = bool
  default     = false
  description = "Boolean flag to enable/disable retention."
}

variable "flow_log_retention_policy_days" {
  type        = number
  default     = 100
  description = "The number of days to retain flow log records."
}

variable "log_analytics_workspace_resource_id" {
  type        = string
  default     = null
  description = "The resource ID of the attached log analytics workspace."
}

variable "enable_traffic_analytics" {
  type        = bool
  default     = false
  description = "Boolean flag to enable/disable traffic analytics."
}

variable "flow_log_version" {
  type        = number
  default     = 1
  description = " The version (revision) of the flow log. Possible values are 1 and 2."
}