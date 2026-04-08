variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "A description of the traffic mirror session. Forces new resource."
  type        = string
  default     = null
}

variable "network_interface_id" {
  description = "The network interface ID that is associated with the target. Forces new resource."
  type        = string
  default     = null

  validation {
    condition     = var.network_interface_id == null || can(regex("^eni-[0-9a-f]{8,17}$", var.network_interface_id))
    error_message = "resource_aws_ec2_traffic_mirror_target, network_interface_id must be a valid ENI ID (format: eni-xxxxxxxx)."
  }
}

variable "network_load_balancer_arn" {
  description = "The Amazon Resource Name (ARN) of the Network Load Balancer that is associated with the target. Forces new resource."
  type        = string
  default     = null

  validation {
    condition     = var.network_load_balancer_arn == null || can(regex("^arn:aws[a-z0-9-]*:elasticloadbalancing:[a-z0-9-]+:[0-9]{12}:loadbalancer/net/[a-zA-Z0-9-]+/[a-z0-9]+$", var.network_load_balancer_arn))
    error_message = "resource_aws_ec2_traffic_mirror_target, network_load_balancer_arn must be a valid Network Load Balancer ARN."
  }
}

variable "gateway_load_balancer_endpoint_id" {
  description = "The VPC Endpoint Id of the Gateway Load Balancer that is associated with the target. Forces new resource."
  type        = string
  default     = null

  validation {
    condition     = var.gateway_load_balancer_endpoint_id == null || can(regex("^vpce-[0-9a-f]{8,17}$", var.gateway_load_balancer_endpoint_id))
    error_message = "resource_aws_ec2_traffic_mirror_target, gateway_load_balancer_endpoint_id must be a valid VPC Endpoint ID (format: vpce-xxxxxxxx)."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}