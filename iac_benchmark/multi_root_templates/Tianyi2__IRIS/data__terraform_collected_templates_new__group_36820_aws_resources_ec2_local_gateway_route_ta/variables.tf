variable "local_gateway_route_table_id" {
  description = "Identifier of EC2 Local Gateway Route Table"
  type        = string

  validation {
    condition     = can(regex("^lgw-rtb-[0-9a-f]+$", var.local_gateway_route_table_id))
    error_message = "resource_aws_ec2_local_gateway_route_table_vpc_association, local_gateway_route_table_id must be a valid Local Gateway Route Table ID format (lgw-rtb-xxxxxxxxxxxxxxxxx)."
  }
}

variable "vpc_id" {
  description = "Identifier of EC2 VPC"
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "resource_aws_ec2_local_gateway_route_table_vpc_association, vpc_id must be a valid VPC ID format (vpc-xxxxxxxxxxxxxxxxx)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ec2_local_gateway_route_table_vpc_association, region must be a valid AWS region format."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[\\w\\s+=.@-]+$", k)) && can(regex("^[\\w\\s+=.@-]*$", v))])
    error_message = "resource_aws_ec2_local_gateway_route_table_vpc_association, tags keys and values must contain only valid characters."
  }
}