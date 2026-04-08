variable "cluster_name" {
  description = "Name of existing IKS cluster"
  type        = string
  nullable    = false
}

variable "ibmcloud_api_key" {
  description = "Get the ibmcloud api key from https://cloud.ibm.com/iam/apikeys"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "portworx_service_name" {
  type        = string
  description = "Name to be provided to the portworx cluster to be deployed"
  default     = "px-backup"
  nullable    = false
}

variable "pwx_backup_plan" {
  description = "Portworx plan type "
  type        = string
  default     = "px-backup-enterprise"
  validation {
    condition     = contains(["px-backup-enterprise"], var.pwx_backup_plan)
    error_message = "The value of `pwx_backup_plan` should be any of the following:\npx-backup-enterprise"
  }
}

variable "region" {
  description = "The region Portworx will be installed in: us-south, us-east, eu-gb, eu-de, jp-tok, au-syd, etc."
  default     = "us-east"
  type        = string
  nullable    = false
}

variable "resource_group" {
  description = "Resource group of existing IKS Cluster "
  type        = string
  nullable    = false
}

variable "tags" {
  type        = list(string)
  description = "Optional Tags to be add, if required."
  default     = []
}

variable "namespace" {
  description = "Namespace to deploy Portworx Backup in the IKS"
  type        = string
  default     = "px-backup-namespace"
}
