variable "global_network_id" {
  description = "ID of the specific global network to retrieve"
  type        = string

  validation {
    condition     = can(regex("^gn-[0-9a-f]{17}$", var.global_network_id))
    error_message = "data_aws_networkmanager_global_network, global_network_id must be a valid global network ID format (gn-[17 hex characters])."
  }
}