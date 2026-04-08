variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "Identifier of the EC2 Route Table to be associated with the VPC Endpoint."
  type        = string

  validation {
    condition     = can(regex("^rtb-[0-9a-f]{8}([0-9a-f]{9})?$", var.route_table_id))
    error_message = "resource_aws_vpc_endpoint_route_table_association, route_table_id must be a valid route table ID starting with 'rtb-'."
  }
}

variable "vpc_endpoint_id" {
  description = "Identifier of the VPC Endpoint with which the EC2 Route Table will be associated."
  type        = string

  validation {
    condition     = can(regex("^vpce-[0-9a-f]{8}([0-9a-f]{9})?$", var.vpc_endpoint_id))
    error_message = "resource_aws_vpc_endpoint_route_table_association, vpc_endpoint_id must be a valid VPC endpoint ID starting with 'vpce-'."
  }
}