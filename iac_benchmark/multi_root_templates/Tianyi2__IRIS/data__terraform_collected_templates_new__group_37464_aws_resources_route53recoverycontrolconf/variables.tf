variable "cluster_arn" {
  description = "ARN of the cluster in which this routing control will reside."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:route53-recovery-control:.*:cluster/.*", var.cluster_arn))
    error_message = "resource_aws_route53recoverycontrolconfig_routing_control, cluster_arn must be a valid Route53 Recovery Control cluster ARN."
  }
}

variable "name" {
  description = "The name describing the routing control."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_route53recoverycontrolconfig_routing_control, name must be between 1 and 64 characters in length."
  }
}

variable "control_panel_arn" {
  description = "ARN of the control panel in which this routing control will reside."
  type        = string
  default     = null

  validation {
    condition     = var.control_panel_arn == null || can(regex("^arn:aws:route53-recovery-control:.*:controlpanel/.*", var.control_panel_arn))
    error_message = "resource_aws_route53recoverycontrolconfig_routing_control, control_panel_arn must be a valid Route53 Recovery Control control panel ARN."
  }
}