variable "name" {
  description = "The name of the resources"
  type        = string
}

variable "project" {
  description = "Project name to which the resource is associated"
  type        = string
}

variable "client" {
  description = "Client to which the resource is associated"
  type        = string
}

variable "owner" {
  description = "Owner of the resource"
  type        = string
}

variable "environment" {
  description = "The environment for this deployment (e.g., dev, prod)"
  type        = string
}

variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}

variable "allowed_ip_ranges" {
  type        = list(string)
  description = "A list of allowed IP ranges."
  default     = []
}
