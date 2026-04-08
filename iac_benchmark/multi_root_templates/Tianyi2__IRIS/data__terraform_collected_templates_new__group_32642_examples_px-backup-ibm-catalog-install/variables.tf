variable "ibmcloud_api_key" {
  description = "Get the ibmcloud api key from https://cloud.ibm.com/iam/apikeys"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "cluster_name" {
  description = "Name of existing IKS cluster"
  type        = string
  nullable    = false
}

variable "resource_group" {
  description = "Resource group of existing IKS Cluster "
  type        = string
  nullable    = false
}

variable "portworx_service_name" {
  type        = string
  description = "Name to be provided to the portworx cluster to be deployed"
  default     = "px-backup"
  nullable    = false
}