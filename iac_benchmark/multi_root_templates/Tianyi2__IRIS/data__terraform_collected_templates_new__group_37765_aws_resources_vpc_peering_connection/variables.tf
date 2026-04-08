variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "peer_owner_id" {
  description = "The AWS account ID of the target peer VPC. Defaults to the account ID the AWS provider is currently connected to, so must be managed if connecting cross-account."
  type        = string
  default     = null
}

variable "peer_vpc_id" {
  description = "The ID of the target VPC with which you are creating the VPC Peering Connection."
  type        = string

  validation {
    condition     = var.peer_vpc_id != null && var.peer_vpc_id != ""
    error_message = "resource_aws_vpc_peering_connection, peer_vpc_id is required and cannot be empty."
  }
}

variable "vpc_id" {
  description = "The ID of the requester VPC."
  type        = string

  validation {
    condition     = var.vpc_id != null && var.vpc_id != ""
    error_message = "resource_aws_vpc_peering_connection, vpc_id is required and cannot be empty."
  }
}

variable "auto_accept" {
  description = "Accept the peering (both VPCs need to be in the same AWS account and region)."
  type        = bool
  default     = null
}

variable "peer_region" {
  description = "The region of the accepter VPC of the VPC Peering Connection. auto_accept must be false, and use the aws_vpc_peering_connection_accepter to manage the accepter side."
  type        = string
  default     = null
}

variable "accepter" {
  description = "An optional configuration block that allows for VPC Peering Connection options to be set for the VPC that accepts the peering connection (a maximum of one)."
  type = object({
    allow_remote_vpc_dns_resolution = optional(bool)
  })
  default = null
}

variable "requester" {
  description = "A optional configuration block that allows for VPC Peering Connection options to be set for the VPC that requests the peering connection (a maximum of one)."
  type = object({
    allow_remote_vpc_dns_resolution = optional(bool)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "1m")
    update = optional(string, "1m")
    delete = optional(string, "1m")
  })
  default = {
    create = "1m"
    update = "1m"
    delete = "1m"
  }
}