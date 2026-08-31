
variable "aws_region" {
  description = "Region"
  type        = string
  default     = "eu-west-3"
}

variable "environment" {
  description = "Environment use as a prefix"
  type        = string
  default     = "dev"
}

variable "office" {
  description = "Office"
  type        = string
  default     = "sockshop"
}

variable "common_tags" {
  type = map(string)
  default = {
    owners      = "architect"
    environment = "dev"
  }
}

##########################################
# EKS
##########################################
variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "benchmark-eks"
}

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster (for example 1.21)"
  type        = string
  default     = null
}
variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

##########################################
# VPC
##########################################
variable "name" {
  type    = string
  default = "benchmark"
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
  type    = string
  default = ""
}